# midiflow

midiflow lets Claude play music through the instruments and effects installed on your Mac. Claude picks the instrument and the sound, renders the notes in the background and hands you the audio file to listen to and keep. No DAW needs to be open.

**Get started:** open the Code tab in Claude Desktop, where takes play right in the conversation, and ask: "Show me my instruments. Then play an eight-second melody in the middle register with a warm keys sound."

## What you can do
- **Your own plug-ins:** Audio Units and VST3 instruments and effects with their presets. Claude adjusts the sound and adds effects.
- **Set a sound by hand:** Claude opens the plug-in's own window, and Apply puts your sound on the track.
- **Projects with several tracks:** each track with its own instrument or audio file (a recording, a sample), level and panning. Every mix is a version of the project that you can compare with the one before and go back to, with effects on the whole mix if you like. Export a project with its mix, each track as audio and, where it has notes, as MIDI, and a project file for your DAW.
- **midiflow Sampler:** plays SFZ, SoundFont and DecentSampler libraries that you put into `~/Music/midiflow/Instruments`.

## Good to know
- Every render starts as a draft, which midiflow deletes after 24 hours, or sooner when drafts take up a lot of disk space. When you like one, tell Claude or press Apply in the plug-in window, and midiflow keeps it.
- Exported projects go to `~/Music/midiflow/Projects`, one folder per project. You can choose another midiflow folder under Configure.
- Plug-ins that need a running DAW, an online login while rendering or a dongle may not work with midiflow.

## Free preview and licence
- Without a licence, midiflow renders 2 minutes of audio with your own plug-ins, at most 16 seconds per render. Reverb tails are free, and failed renders get their seconds back, up to 32 seconds in all. Listening, browsing your plug-ins and presets and mixing finished takes are always free.
- To buy a licence, ask Claude: it gives you a link, you pay in your browser, never in the chat, and midiflow unlocks itself on this Mac without a key to type. To use the licence on another Mac, ask Claude there to activate it with the key that "check midiflow" shows on this one.

## Requirements
- macOS 14 or later on a Mac with Apple Silicon.
- Audio Units or VST3 plug-ins built for Apple Silicon.

## Privacy
midiflow sends no usage data. It goes online only to read midiflow's update notice and a list of free plug-ins from midiflow.pro, to count the free preview and check your licence at license.midiflow.pro, to download files you ask for, and to send a problem report once you have seen it and agreed. For the preview and the licence it sends codes computed from your Mac's hardware ID (the ID itself never leaves the Mac), the seconds and a checksum of each free render (nothing about your music can be read from it) and your licence key. A report goes to high5 ventures GmbH through its server in Germany and is stored at GitHub in the USA. Details: [privacy notice](https://www.midiflow.pro/en/privacy.html)

## Help
If something does not work, ask Claude to check midiflow. Website: [www.midiflow.pro](https://www.midiflow.pro) · Support: [support@midiflow.pro](mailto:support@midiflow.pro)

midiflow is proprietary software by high5 ventures GmbH. VST is a registered trademark of Steinberg Media Technologies GmbH.

## Try it
- "Use midiflow. Show me my instruments. Then play an eight-second melody in the middle register with a warm keys sound."
- "Use midiflow. Write a C major scale from C4 to C6 and back and render it with a bright pluck sound."
- "Use midiflow. Play an eight-second lead melody around C5, then render it again with a second preset so I can compare both takes."

No account or sign-up is needed. These prompts also work on a Mac without any plug-ins, with midiflow's built-in sounds.

## What this plugin runs and downloads
This plugin holds no program files. It holds this README, the licence, its settings, an icon and one short shell script that you can read: `scripts/start`. Claude runs that script to start midiflow.

- **First start:** the script downloads the midiflow package of exactly this plugin version, about 23 MB, from https://www.midiflow.pro/download/midiflow-1.0.0.mcpb. It checks the file against the SHA-256 written in the script and does not use it if the checksum differs.
- **Where it goes:** the script unpacks the package into the plugin's data folder, which Claude Code keeps under `~/.claude/plugins/data/` and removes when you uninstall the plugin.
- **What it is:** the same package you get from the download on midiflow.pro. Its programs are signed by high5 ventures GmbH and notarized by Apple.
- **Later starts:** the script starts the unpacked server and downloads nothing. When the plugin moves to a new version, the script downloads that version once and removes the old one.
- **Slow connections:** Claude gives a server 30 seconds to start. If the download takes longer, start Claude again; the download continues where it stopped.

## Where it runs
midiflow runs on your Mac. Claude starts a plugin's local server in Claude Code and in Cowork sessions on your computer, not in a chat. For the chat in Claude Desktop, install the download from https://www.midiflow.pro/en/start.html instead. One way to install midiflow is enough.

The folder settings of this plugin take one folder each. If you need several plug-in or instrument folders, use the download from midiflow.pro.

## Help
Write to support@midiflow.pro, or ask Claude to check midiflow. Claude can also send a problem report for you after you have seen it and agreed. Security reports go to the same address.
