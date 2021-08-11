#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# MastodonでTootする。
# CreatedAt: 2021-08-09
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	IsExistCmd() { type $1 >/dev/null 2>&1; }
	GetEditor() { for editor in 'pluma geany vim ed'" $EDITOR"; do { IsExistCmd $editor && { echo $editor; return; } } done; }
	local EDITOR=$(GetEditor)
	QuickEdit() (  trap 'rm /tmp/work/temp$$' exit; vim /tmp/work/temp$$ >/dev/tty; cat /tmp/work/temp$$ )
	UrlEncode() { python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	AccessToken() { cat 'token.txt'; }
	MASTODON_HOST='mstdn.jp'
	ACCESS_TOKEN="$(AccessToken)"
	Toot() {
		TEXT="$(cat -)"
		STATUS="$(echo -e "$TEXT" | UrlEncode)"
		curl -X POST -Ss https://${MASTODON_HOST}/api/v1/statuses \
		  --header "Authorization: Bearer ${ACCESS_TOKEN}" \
		  -d "status=${STATUS}"
	}
	QuickEdit | Toot
}
Run "$@"
