#!/bin/bash

# CONFIG: How many sink channels do you need?
# For example: two for skype and two for youtube → 4
sinkchans=4

# CONFIG: How many source channels do you need?
# Probably none
sourcechans=2

pacmd unload-module module-jackdbus-detect 2>/dev/null


if [ $sinkchans -gt 0 ] ; then
    pacmd unload-module module-jack-sink 2>/dev/null
    pacmd unload-module module-remap-sink 2>/dev/null
    pacmd load-module module-jack-sink sink_name=jack_sink channels=$sinkchans
fi

if [ $sourcechans -gt 0 ] ; then
    pacmd unload-module module-jack-source 2>/dev/null
    pacmd unload-module module-remap-source 2>/dev/null
    pacmd load-module module-jack-source source_name=jack_source channels=$sourcechans
fi

declare -a chname=(
    'front-left' 'front-right'
    'rear-left' 'rear-right'
    'lfe'
    'subwoofer'
    'side-left' 'side-right');

add_stereo_sink() {
    local sinkname=jack_sink_to_remap-`pactl list sinks short | wc -l`
    pacmd load-module module-remap-sink \
          sink_name=$sinkname\
	  master=jack_sink \
	  channels=2 \
	  channel_map=front-left,front-right \
	  master_channel_map=${chname[$1-1]},${chname[$2-1]} \
	  remix=no
    pacmd update-sink-proplist $sinkname device.description="$3"
}

add_mono_sink() {
    local sinkname=jack_sink_to_remap-`pactl list sinks short | wc -l`
    pacmd load-module module-remap-sink \
          sink_name=$sinkname \
	  master=jack_sink \
	  channels=1 \
	  channel_map=front-left \
	  master_channel_map=${chname[$1]} \
	  remix=no
    pacmd update-sink-proplist $sinkname device.description="$2"
}

add_stereo_source() {
    local sourcename=jack_source_to_remap-`pactl list sources short | wc -l`
    pacmd load-module module-remap-source \
          source_name=$sourcename \
	  master=jack_source \
	  channels=2 \
	  channel_map=front-left,front-right \
	  master_channel_map=${chname[$1-1]},${chname[$2-1]} \
	  remix=no
    pacmd update-source-proplist $sourcename device.description="$3"
}

add_mono_source() {
    local sourcename=jack_source_to_remap-`pactl list sources short | wc -l`
    pacmd load-module module-remap-source \
          source_name=$sourcename \
	  master=jack_source \
	  channels=1 \
	  channel_map=front-left \
	  master_channel_map=${chname[$1]} \
	  remix=no
    pacmd update-source-proplist $sourcename device.description="$2"
}

# CONFIG: How should the sinks be remapped?
# example:
# * stereo sink to channel 1 and 2 for youtube
# * one mono sink to channel 3 for skype
# * one mono sink to channel 4 for mumble
add_stereo_sink 1 2 youtube
add_mono_sink 3 skype
add_mono_sink 4 mumble

# CONFIG: How should the sources be remapped?
# example see above.
add_mono_source 1 skype
add_mono_source 2 mumble
