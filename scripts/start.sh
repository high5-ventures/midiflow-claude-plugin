#!/bin/sh
# Starts the midiflow server of this plugin version.
#
# The plugin holds no program files. On the first start, and after the plugin moved to a new version, this script
# downloads the notarized midiflow package of exactly this version from midiflow.pro, checks it against the SHA-256
# below and unpacks it into the plugin's data folder. Then it starts the server from there. Later starts use the
# unpacked copy and do not download anything.
#
# stdout belongs to the MCP connection, so every message goes to stderr.
set -eu

sha256='8967e1ba9a4a2a8254b016865c0c80886d928b096ab5f26295869fe73679f72a'

# The settings arrive under the names the directory accepts; the server reads its own.
export MIDIFLOW_CFG_OUTPUT_DIR="${CLAUDE_PLUGIN_OPTION_OUTPUT_DIR:-}"
export MIDIFLOW_CFG_PREFERRED_FORMAT="${CLAUDE_PLUGIN_OPTION_PREFERRED_FORMAT:-}"
export MIDIFLOW_CFG_MAX_PARALLEL_RENDERS="${CLAUDE_PLUGIN_OPTION_MAX_PARALLEL_RENDERS:-}"
export MIDIFLOW_CFG_NOTE_NAME_CONVENTION="${CLAUDE_PLUGIN_OPTION_NOTE_NAME_CONVENTION:-}"
export MIDIFLOW_CFG_OVERLOAD_MODE="${CLAUDE_PLUGIN_OPTION_OVERLOAD_MODE:-}"
export MIDIFLOW_INSTALL_CHANNEL='plugin'

say() { printf 'midiflow: %s\n' "$*" >&2; }
die() { say "$*"; exit 1; }

[ "$(/usr/bin/uname -s)-$(/usr/bin/uname -m)" = 'Darwin-arm64' ] || die 'midiflow needs a Mac with Apple Silicon.'

data="${CLAUDE_PLUGIN_DATA:-$HOME/Library/Application Support/midiflow/plugin}"
program="$data/1.0.0/bin/midiflow"

if [ ! -x "$program" ]; then
  /bin/mkdir -p "$data"

  # Several Claude windows can start at once. shlock takes over a lock whose process has died.
  lock="$data/install.lock"
  until /usr/bin/shlock -f "$lock" -p "$$"; do /bin/sleep 1; done
  trap '/bin/rm -f "$lock"' EXIT

  if [ ! -x "$program" ]; then
    checks_out() { [ -f "$data/download/package.mcpb" ] && [ "$(/usr/bin/shasum -a 256 "$data/download/package.mcpb" | /usr/bin/cut -d ' ' -f 1)" = "$sha256" ]; }

    if ! checks_out; then
      say 'downloading midiflow 1.0.0 from midiflow.pro'
      # An interrupted download continues where it stopped: Claude gives a server 30 seconds to start. A piece left by
      # another version fails the checksum below and goes.
      status=0
      /bin/mkdir -p "$data/download"
      (cd "$data/download" && exec /usr/bin/curl --fail --location --silent --show-error --proto '=https' --proto-redir '=https' \
        --tlsv1.2 --connect-timeout 15 --continue-at - --output package.mcpb 'https://www.midiflow.pro/download/midiflow-1.0.0.mcpb') >&2 || status=$?
      # The server refused this file or the resume: start over next time.
      case "$status" in 22 | 33) /bin/rm -f "$data/download/package.mcpb" ;; esac
      [ "$status" -eq 0 ] || die "the download stopped (exit code $status). Start Claude again to continue. Details: https://www.midiflow.pro/en/start.html"
      if ! checks_out; then
        /bin/rm -f "$data/download/package.mcpb"
        die 'the download does not match the checksum of midiflow 1.0.0, so it was not used.'
      fi
    fi

    /bin/rm -rf "$data/unpack"
    /bin/mkdir "$data/unpack"
    # unzip, not ditto: the package stores modes without file-type bits, and ditto then drops the execute bit.
    /usr/bin/unzip -q "$data/download/package.mcpb" -d "$data/unpack" >&2 || die 'the midiflow 1.0.0 package could not be unpacked.'
    [ -x "$data/unpack/bin/midiflow" ] || die 'the midiflow 1.0.0 package holds no server.'
    /bin/rm -rf "$data/1.0.0"
    /bin/mv "$data/unpack" "$data/1.0.0"

    # The download and earlier versions go, unless a Claude window is still running one.
    for old in "$data"/*/; do
      old="${old%/}"
      if [ "$old" != "$data/1.0.0" ] && ! /usr/bin/pgrep -f "$old/bin/midiflow" >/dev/null 2>&1; then
        /bin/rm -rf "$old"
      fi
    done
  fi

  trap - EXIT
  /bin/rm -f "$lock"
fi

exec "$program" "$@"
