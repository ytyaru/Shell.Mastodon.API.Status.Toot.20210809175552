#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# https://docs.joinmastodon.org/methods/statuses/
# CreatedAt: 2021-08-11
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	. "../lib/Error.sh"
	VERSION=0.0.1
	Help() { eval "cat <<< \"$(cat "./help/statuses.txt")\""; exit 1; }
	TEXT=; DATE_TIME=; MEDIA_IDS=; POOL_OPTIONS=; REPLY_ID=; IS_SENSITIVE=0; SPOILER_TEXT=; VISIBILITY=public; LANGUAGE=; MEDIA_IDS=(); POOL_OPTIONS=(); POLL_EXPIRES_IN=$(( 60 * 60 * 24 )); IS_POLL_MULTIPLE=0;
	GetArgs() {
		while getopts :t:d:r:sS:v:l:m:p:P:Mh OPT; do case $OPT in
			d) DATE_TIME=$OPTARG;;
			r) REPLY_ID=$OPTARG;;
			s) IS_SENSITIVE=1;;
			s) SPOILER_TEXT="$OPTARG";;
			v) VISIBILITY="$OPTARG";;
			l) LANGUAGE="$OPTARG";;
			m) MEDIA_IDS+=($OPTARG);;
			p) POOL_OPTIONS+=("$OPTARG");;
			P) POLL_EXPIRES_IN=$OPTARG;;
			M) IS_POLL_MULTIPLE=1;;
			h|\?) Help; exit;;
		esac; done;
		shift $((OPTIND - 1))
		[ -z "$TEXT" ] && [ 0 -lt $# ] && TEXT="$1" || :
		[ -z "$TEXT" ] && TEXT="$(cat -)" || :
		# ===== Validation =====
		# DATE_TIME: ISO8601 & 5m ago
		# VISIBILITY: public, unlisted, private, direct
		# LANGUAGE: ISO639
	}
	GetArgs "$@"
	echo "TEXT=$TEXT"

#	UrlEncode() { python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
	UrlEncode() { echo -e "$1" | python -c 'import sys, urllib; print urllib.quote(sys.stdin.read()),'; }
#	Host() { cat 'host.txt'; }
	Host() { local F='host.txt'; [ -f "$F" ] && cat "$F" || { Throw "$Fがありません。マストドンのインスタンスサーバのドメイン名を入力したファイルを用意してください。"; } }
	AccessToken() { local F='token.txt'; [ -f "$F" ] && cat "$F" || { Throw "$Fがありません。アクセストークンを入力したファイルを用意してください。"; } }
	MASTODON_HOST="$(Host)"
	ACCESS_TOKEN="$(AccessToken)"
#	TEXT=${1:-'APIでテスト投稿してみた。\n改行も 半角スペース もURLエンコードされること。\n#mastodon #api'}
	STATUS="$(UrlEncode "$TEXT")"
	Toot() {
		curl -X POST -Ss https://${MASTODON_HOST}/api/v1/statuses \
		  --header "Authorization: Bearer ${ACCESS_TOKEN}" \
		  -d "status=${STATUS}"
	}
	MakeParams() {
		local PARAM=;
		declare -A P
		P['status']="$(UrlEncode "$TEXT")"
		[ -n "$DATE_TIME" ] && P['scheduled_at']="$(UrlEncode "$DATE_TIME")" || :
		[ -n "$REPLY_ID" ] && P['in_reply_to_id']="$(UrlEncode "$REPLY_ID")" || :
		[ 1 -eq $IS_SENSITIVE ] && P['sensitive']="$(UrlEncode "$IS_SENSITIVE")" || :
		[ -n "$SPOILER_TEXT" ] && P['spoiler_text']="$(UrlEncode "$SPOILER_TEXT")" || :
		[ -n "$VISIBILITY" ] && P['visibility']="$(UrlEncode "$VISIBILITY")" || :
		[ -n "$LANGUAGE" ] && P['language']="$(UrlEncode "$LANGUAGE")" || :
		[ -n "$MEDIA_IDS" ] && P['media_ids']="$(UrlEncode "$MEDIA_IDS")" || :
		[ -n "$POLL_OPTIONS" ] && P['poll_options']="$(UrlEncode "$POLL_OPTIONS")"|| :
		[ -n "$POLL_EXPIRES_IN" ] && P['poll_expires_in']="$(UrlEncode "$POLL_EXPIRES_IN")" || :
		[ 1 -eq $IS_POLL_MULTIPLE ] && P['poll_multiple']="$(UrlEncode "$IS_POLL_MULTIPLE")" || :
		for key in "${!P[@]}"; do
			PARAM+=" ${key}=${P[$key]}"
		done
		echo "$PARAM"
	}
	MakeJson() {
		Quote() { echo '"'"$1"'"'; }
		ToStr() { Quote "$1"; }
		ToNum() { echo "$1"; }
		ToBool() { [ 1 -eq $1 ] && echo 'true' || echo 'false'; }
		ToKV() { echo "$1:$2"; }
#		ToAry() {}
#		ToObj() {}
		PARAMS=()
		local JSON=;
		declare -A P
		P['status']="$(UrlEncode "$TEXT")"
		[ -n "$DATE_TIME" ] && P['scheduled_at']="$(UrlEncode "$DATE_TIME")" || :
		[ -n "$REPLY_ID" ] && P['in_reply_to_id']="$(UrlEncode "$REPLY_ID")" || :
		[ 1 -eq $IS_SENSITIVE ] && P['sensitive']="$(UrlEncode "$IS_SENSITIVE")" || :
		[ -n "$SPOILER_TEXT" ] && P['spoiler_text']="$(UrlEncode "$SPOILER_TEXT")" || :
		[ -n "$VISIBILITY" ] && P['visibility']="$(UrlEncode "$VISIBILITY")" || :
		[ -n "$LANGUAGE" ] && P['language']="$(UrlEncode "$LANGUAGE")" || :
		[ -n "$MEDIA_IDS" ] && P['media_ids']="$(UrlEncode "$MEDIA_IDS")" || :
		[ -n "$POLL_OPTIONS" ] && P['poll_options']="$(UrlEncode "$POLL_OPTIONS")"|| :
		[ -n "$POLL_EXPIRES_IN" ] && P['poll_expires_in']="$(UrlEncode "$POLL_EXPIRES_IN")" || :
		[ 1 -eq $IS_POLL_MULTIPLE ] && P['poll_multiple']="$(UrlEncode "$IS_POLL_MULTIPLE")" || :
		for key in "${!P[@]}"; do
			PARAM+=" ${key}=${P[$key]}"
		done
		
		declare -A P_STR
		[ -n "$TEXT" ] && P['status']="$(UrlEncode "$TEXT")" || :
		[ -n "$DATE_TIME" ] && P['scheduled_at']="$(UrlEncode "$DATE_TIME")" || :
		[ -n "$REPLY_ID" ] && P['in_reply_to_id']="$(UrlEncode "$REPLY_ID")" || :
		[ -n "$SPOILER_TEXT" ] && P['spoiler_text']="$(UrlEncode "$SPOILER_TEXT")" || :
		[ -n "$VISIBILITY" ] && P['visibility']="$(UrlEncode "$VISIBILITY")" || :
		[ -n "$LANGUAGE" ] && P['language']="$(UrlEncode "$LANGUAGE")" || :
		for key in "${!P_STR[@]}"; do
			PARAMS+=("$(ToKV "$key" "$(ToStr "${P_STR[$key]}")")")
		done
		declare -A P_BOOL
		[ 1 -eq $IS_SENSITIVE ] && P['sensitive']="$(UrlEncode "$IS_SENSITIVE")" || :
		[ 1 -eq $IS_POLL_MULTIPLE ] && P['poll_multiple']="$(UrlEncode "$IS_POLL_MULTIPLE")" || :
		for key in "${!P_BOOL[@]}"; do
			PARAMS+=("$(ToKV "$key" "$(ToStr "${P_BOOL[$key]}")")")
		done
		declare -A P_ARY
		[ -n "$MEDIA_IDS" ] && P['media_ids']="$(UrlEncode "$MEDIA_IDS")" || :

		JSON+='{'
		JSON+="$(Quote "$key")"
		JSON+=':'
		JSON+="$(Quote "${P[$key]}")"
		JSON+='"'
		JSON+="${key}"
		JSON+='"'
		JSON+=':'
		JSON+='}'
		echo "$PARAM"

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
