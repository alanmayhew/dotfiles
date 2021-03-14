#!/bin/sh

usage () {
    echo "Usage: $0 [start-dir] [session-name]"
    echo "    start-dir: working directory for session"
    echo "    session-name: session will be called session-name"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

if [ $# -ge 1 ]; then
    if [ "$1" = "-h" ]; then
        usage
        exit 0
    fi
    startdir="$1"
    if [ $# -gt 1 ]; then
        sname="$2"
    else
        sname=$(basename $1)
    fi
fi

sname="$sname"

tmux new-session -d -s "$sname" -c "$startdir"
tmux rename-window -t "$sname:0" "src"
tmux new-window -n "git" -c "$startdir"
tmux new-window -n "test" -c "/tmp"
tmux new-window -n "build" -c "$startdir"
tmux select-window -t "$sname:src"
tmux attach-session -t "$sname"
