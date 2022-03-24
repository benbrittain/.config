#!/usr/bin/env bash

# Terminate already running instances
polybar-msg cmd quit

polybar -c $HOME/.config/polybar/config.ini &

echo "Bars launched..."
