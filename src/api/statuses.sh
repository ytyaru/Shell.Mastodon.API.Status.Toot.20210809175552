#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# https://docs.joinmastodon.org/methods/statuses/
# CreatedAt: 2021-08-11
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	Help() { eval "cat <<< \"$(cat "./help/statuses.txt")\""; exit 1; }
	TEXT="$(cat -)"
	while getopts s:d:h OPT; do
	case $OPT in
		d) DATE_TIME=$OPTARG;;
		m) MEDIA_IDS+=($OPTARG);;
		p) POOL_OPTIONS+=($OPTARG);;
		h|\?) Help; exit;;
	esac
	shift $((OPTIND - 1))

	UrlEncode() { python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	Host() { cat 'host.txt'; }
	AccessToken() { cat 'token.txt'; }
	MASTODON_HOST="$(Host)"
	ACCESS_TOKEN="$(AccessToken)"
	TEXT=${1:-'APIでテスト投稿してみた。\n改行も 半角スペース もURLエンコードされること。\n#mastodon #api'}
	STATUS="$(echo -e "$TEXT" | UrlEncode)"
	Toot() {
		curl -X POST -Ss https://${MASTODON_HOST}/api/v1/statuses \
		  --header "Authorization: Bearer ${ACCESS_TOKEN}" \
		  -d "status=${STATUS}"
	}
	Toot
#	TEXT='APIでテスト投稿してみた。二回目。\n改行も 半角スペース もURLエンコードされること。\n#mastodon #api'
#	curl -X POST -Ss https://${MASTODON_HOST}/api/v1/statuses \
#	  --header "Authorization: Bearer ${ACCESS_TOKEN}" \
#	  -d "status=${STATUS}" \
#	>| response.json
#	python -m json.tool response.json
}
Run "$@"
