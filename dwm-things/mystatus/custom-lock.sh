#!/bin/sh

bg_file=$(cat /home/mayhea/.fehbg | sed -n -r "s/^.*--bg\S+\s+'(\S+)'.*$/\1/p")
i3lock -i $bg_file
