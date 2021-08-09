# token/outh

　エラーになってしまう。どうすれば解決するの？

```javascript
{"error":"invalid_grant","error_description":"The provided authorization grant is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client."}
```

　パラメータ`username`にアカウント登録したときのメールアドレスをセットするとよい。ユーザ名では上記エラーになる。

# 返信する

　既存のtootに返信したい。このときtootのidが必要。

　git pushしたとき、git init でリポジトリしたときは最初にtootする。二回目以降のgit commitでは、そのtootへ返信する。reply。

* [Mastodon API で「返信」をトゥートする 1 行サンプル（bash, PHP）](https://qiita.com/KEINOS/items/68ae99c7f98fe309f9bf)


