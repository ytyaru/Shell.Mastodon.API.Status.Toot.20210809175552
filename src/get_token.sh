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
	[ ! -f user.tsv ] && { echo 'Not found user.tsv'; exit 1; }
	UrlEncode() { echo -n "$1" | python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	IsExistCmd() { type $1 >/dev/null 2>&1; }
	Install() { sudo apt install -y $1; }
	OnceInstall() { IsExistCmd $1 || Install $1; }
	OnceInstall jq
	MASTODON_HOST=mstdn.jp
	ENDPOINT=https://$MASTODON_HOST/oauth/token
	CLIENT_ID="$(cat app.json | jq -r '.client_id')"
	CLIENT_SECRET="$(cat app.json | jq -r '.client_secret')"
#	REDIRECT_URI="$(cat app.json | jq -r '.redirect_uri')"
#	USERNAME=$(cat user.tsv | cut -f1)
	EMAIL=$(cat user.tsv | cut -f2)
	PASSWORD=$(cat user.tsv | cut -f3)
	SCOPE='read write follow push'
	GetToken() {
		curl -X POST -sS $ENDPOINT \
		  -d "client_id=$(UrlEncode $CLIENT_ID)" \
		  -d "client_secret=$(UrlEncode $CLIENT_SECRET)" \
		  -d "grant_type=password" \
		  -d "username=$(UrlEncode $EMAIL)" \
		  -d "password=$(UrlEncode $PASSWORD)" \
		  -d "scope=$SCOPE" \
		  -o token.json
	}
	GetToken
	cat token.json | jq -r '.access_token' > token.txt
#	cat token.json | jq -r '.access_token' |> token.txt
}
Run "$@"
