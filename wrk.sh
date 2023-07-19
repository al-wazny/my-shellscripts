#!/bin/bash

while getopts "c" option; do
	case $option in
		c) chill=true;;
	esac
done

execWithoutOutput() {
	$1 > /dev/null 2>&1 &
}

startApp() {
	pgrep -x $1 > /dev/null || flatpak run $1 > /dev/null 2>&1 &
}

moveToNextWorkspace() {
	xdotool set_desktop --relative 1
}

startProject() {
	cd ~/repos/waldhausen-shopware
	
	make start
	make ssh
}

startWorkEnv() {
	execWithoutOutput "xdg-open http://localhost:8080"
	sleep 3
	moveToNextWorkspace
	execWithoutOutput phpstorm
	moveToNextWorkspace
	startProject
}

startApp com.slack.Slack
startApp com.spotify.Client

sleep 3

moveToNextWorkspace

execWithoutOutput "xdg-open https://outlook.office.com/mail/"		
execWithoutOutput "xdg-open https://flagbit.atlassian.net/plugins/servlet/ac/io.tempo.jira/tempo-app#!/my-work/week?type=LIST"

if [  "$chill" ]; then
	execWithoutOutput "xdg-open http://google.com"	
else
	startWorkEnv
fi

