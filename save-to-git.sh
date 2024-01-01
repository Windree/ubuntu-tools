#!/bin/env bash

set -Eeuo pipefail

tmp=$(mktemp -d)

function main(){
	git clone git@gitee.com:windree/ubuntu-config.git "$tmp"  > /dev/null  2>/dev/null
	crontab -l > "$tmp/crontab.txt"

	mkdir -p "$tmp/media/app/mutt"
	cp -a "/media/app/mutt/.env" "$tmp/media/app/mutt/"

	mkdir -p "$tmp/etc/"
	cp -a "/etc/fstab" "$tmp/etc/"

	mkdir -p "$tmp/etc/docker"
	cp -a "/etc/docker/daemon.json" "$tmp/etc/docker/"
		
	mkdir -p "$tmp/home/"
	mkdir -p "$tmp/home/tunnel/.ssh"
	mkdir -p "$tmp/home/.ssh"
	mkdir -p "$tmp/media/app/ubuntu-tools/"
	
	cp -a $HOME/.bash_aliases "$tmp/home/"
	cp -a $HOME/cifs.*.conf "$tmp/home/"
	cp -a $HOME/.ssh/authorized_keys "$tmp/home/.ssh/"
	cp -a /home/tunnel/.ssh/authorized_keys "$tmp/home/tunnel/.ssh/"
	cp -a /media/app/ubuntu-tools/*.sh.env "$tmp/media/app/ubuntu-tools/"

	local status=$(git -C "$tmp" status -s)
	if [[ -z "$status" ]]; then 
		exit
	fi
	git -C "$tmp" status -s
	git -C "$tmp" add . > /dev/null
	git -C "$tmp" commit -m "$(date)" > /dev/null
	git -C "$tmp" push
}

function cleanup(){
	if [ -d "$tmp" ] && ! rm -rf "$tmp"; then
		echo "Can't delete temp directory"
		exit 1
	fi
}

trap "cleanup" EXIT

main