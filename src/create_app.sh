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
	[ -f app.json ] && return
	UrlEncode() { echo -n "$1" | python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	MASTODON_HOST=mstdn.jp
	ENDPOINT=https://$MASTODON_HOST/api/v1/apps
	SCOPES='read write follow'
	CLIENT_NAME='TootShellScript'
	REDIRECT_URIS=urn:ietf:wg:oauth:2.0:oob
	WEBSITE=https://github.com/ytyaru/Shell.Mastodon.API.Status.Toot.20210809175552
	CreateApp() {
		curl -X POST -sS $ENDPOINT \
		  -d "client_name=$(UrlEncode $CLIENT_NAME)" \
		  -d "redirect_uris=$(UrlEncode $REDIRECT_URIS)" \
		  -d "scopes=$(UrlEncode $SCOPES)" \
		  -d "website=$(UrlEncode $WEBSITE)" \
		  -o app.json
	}
	CreateApp
}
Run "$@"
