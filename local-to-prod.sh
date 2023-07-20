#!/bin/bash

while getopts "s:v:" opt; do
	case "$opt" in
		s) server=$OPTARG;;
		v) version=$OPTARG;;
	esac
done

# Function to check if a string matches the software version format (x.y.z)
is_valid_version() {
  if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]$ ]]; then
    return 0
  else
    return 1
  fi
}

if [ -z "$server" ]; then
    echo 'Missing -s (specify prod server)' >&2
    exit 1
fi

if [ ! -z "$version" ] && is_valid_version "$version"; then
    echo "$version" > /home/ali/repos/shell/version.txt
else
    version=$(cat /home/ali/repos/shell/version.txt)
fi

git add .

git commit -m "release v$version"

git push origin main

ssh $server "git pull origin main"
