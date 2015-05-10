# jack pulseaudio bridge

Use several audio instances (skype, mumble, browser) and map them into the jack
world.


## The problem

Imaging you are recording a podcast with a remote speaker connected to you by
some VoIP application like Skype or Mumble. VoIP clients usually come with a
Pulseaudio backend and show up as Pulseaudio streams. Pulseaudio has a jack
sink and source bridge modules that can transfer audio streams from jack to
pulseaudio and vice versa.

Unfortunately you can load the bridge modules only once, so that you are
limited to one audio stream per direction. Here a simple shell script is used
to circumvent this problem.


## How it works.

As we said, you can only load one instance of the jack pulseaudio bridge
modules, but this bridge can have an arbitrary numbers of channels. Pulseaudio
furthermore has a remap module that can map channels of one sink into
channels of a new virtual sink. That's all we need.

The shell script sets up a jack sink or source respectively with the needed
numbers of channels. Then it adds virtual sinks or sources and remaps channels
to the bridge sink or source.


## What you need

The following ubuntu packages or equivalent

* pulseaudio-utils

and of course some jackd installation.


## How to use it

It's a hack and it assumes that you have basic hacking skills. Go through
`jack-pulseaudio-bridge.sh` and search for the comment string `CONFIG`. The
comments there should explain, how to configure the shell script.

Run it after jackd is started. Then your pulseaudio sinks and sources should
show up. You can route your audio streams to them.
