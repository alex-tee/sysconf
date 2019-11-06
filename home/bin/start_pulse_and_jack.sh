#!/usr/bin/env bash
pulseaudio &
sleep 6
qjackctl --start
