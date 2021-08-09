#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# MastodonでTootする。
# CreatedAt: 2021-08-09
# https://docs.joinmastodon.org/methods/apps/
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	[ -f token.json ] && return
	UrlEncode() { echo -n "$1" | python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	IsExistCmd() { type $1 >/dev/null 2>&1; }
	Install() { sudo apt install -y $1; }
	OnceInstall() { IsExistCmd $1 || Install $1; }
	OnceInstall jq
	MASTODON_HOST=mstdn.jp
	ENDPOINT=https://$MASTODON_HOST/oauth/token
	CLIENT_ID="$(cat app.json | jq -r '.client_id')"
	CLIENT_SECRET="$(cat app.json | jq -r '.client_secret')"
	USERNAME=$(cat user.tsv | cut -f1)
	EMAIL=$(cat user.tsv | cut -f2)
	PASSWORD=$(cat user.tsv | cut -f3)
	SCOPE='read write follow'
#	REQ_JSON="{\"client_id\": \"$CLIENT_ID\", \"client_secret\": \"$CLIENT_SECRET\", \"grant_type\": \"password\", \"username\": \"$EMAIL\", \"password\": \"$PASSWORD\", \"scope\": \"$SCOPE\"}"
#	echo $REQ_JSON
#	return
#	GetToken() {
#		curl -H "Content-Type: application/json" \
#		  -X POST -sS $ENDPOINT \
#		  -d "$REQ_JSON" \
#		  -o token.json
#	}
	GetToken() {
		curl -X POST -sS $ENDPOINT \
		  -d "client_id=$(UrlEncode $CLIENT_ID)" \
		  -d "client_secret=$(UrlEncode $CLIENT_SECRET)" \
		  -d "grant_type=password" \
		  -d "username=$(UrlEncode $USERNAME)" \
		  -d "password=$(UrlEncode $PASSWORD)" \
		  -d "scope=$(UrlEncode $SCOPE)" \
		  -o token.json
	}
	GetToken
	cat token.json | jq -r '.access_token' |> token.txt
}
Run "$@"
