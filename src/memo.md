# token/outh

　エラーになってしまう。どうすれば解決するの？

```javascript
{"error":"invalid_grant","error_description":"The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client."}
```

　パラメータ`username`にアカウント登録したときのメールアドレスをセットするとよい。ユーザ名では上記エラーになる。

## スコープ設定

* https://mstdn.jp/web/statuses/106730477288142271

　Mastodon の API /api/v1/apps と /oauth/token でスコープが必ず read のみになってしまう。（デフォルト値）

* https://docs.joinmastodon.org/methods/apps/
* https://docs.joinmastodon.org/methods/apps/oauth/

　原因はscopeやscopes引数をURLエンコードしていたせい。
　スペースを含めてエンコードせずそのまま渡したら成功した。

# 返信する

　既存のtootに返信したい。このときtootのidが必要。

　git pushしたとき、git init でリポジトリしたときは最初にtootする。二回目以降のgit commitでは、そのtootへ返信する。reply。

* [Mastodon API で「返信」をトゥートする 1 行サンプル（bash, PHP）](https://qiita.com/KEINOS/items/68ae99c7f98fe309f9bf)

# status API

　Tootするときはstatus APIを使う。色々な機能がある。

* https://docs.joinmastodon.org/methods/statuses/#deprecated-methods

引数|型|概要
----|--|----
`status`|string|Toot本文。

引数|型|概要
----|--|----
`in_reply_to_id`|string|指定したTootIDへのリプライ(返信)するときに指定する。
`visibility`|string|公開範囲。`public`, `unlisted`, `private`, `direct`。
`sensitive`|boolean|警告するか否か。
`spoiler_text`|警告テキスト。
`language`|言語コード。ISO639。

引数|型|概要
----|--|----
`scheduled_at`|string|予約投稿。最低でも5分後であるべき。`2019-12-05T12:33:01.000Z`, `2019-12-05T12:33:01.000+0900`

引数|型|概要
----|--|----
`media_ids`|array|画像、音声、動画のID。[media][] APIのレスポンスから得られる。

引数|型|概要
----|--|----
`poll[options]`|array|可能な答えの配列。`poll[expires_in]`を指定せねばならない。
`poll[expires_in]`|number|有効な時間(秒)。
`poll[multiple]`|boolean|複数の質問をするか否か。

* [media](https://docs.joinmastodon.org/methods/statuses/media/)
