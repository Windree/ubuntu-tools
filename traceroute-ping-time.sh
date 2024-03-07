#!/usr/bin/env bash
time=$(traceroute "$1" --tries 1 --max-hop=15 --wait=1 | grep -oP "[\d\.]+\w+" | tail -n 1)
echo $1 $time
