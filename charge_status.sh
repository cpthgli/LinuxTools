#!/bin/zsh

while; do
  echo status=$(cat /sys/class/power_supply/BAT0/status)
  echo capacity=$(cat /sys/class/power_supply/BAT0/capacity)
  echo current_now=$(cat /sys/class/power_supply/BAT0/current_now)
  echo charge_now=$(cat /sys/class/power_supply/BAT0/charge_now)
  echo
  sleep 0.5s
done
