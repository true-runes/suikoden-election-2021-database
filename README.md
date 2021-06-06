# suikoden-election-2021-database

- 幻水総選挙 2021 データベース

# コマンド集

## データベースに格納してあるユーザーの公開状態を全チェックし、データの更新する

- ユーザー数 1,450 件 で 約 2.5 分を要した

```bash
$ $(which bundle) exec rails runner "TwitterRestApi::CheckProtectedUsers.new.update_all_user_is_protected_statuses"
```

## データベースに格納してあるツイートの公開状態を全チェックし、データの更新する

- ツイート 7,328 件 で 約 7 分を要した

```
$(which bundle) exec rails runner "TwitterRestApi::CheckPublicTweets.new.update_all_tweet_is_public_statuses"
```

## 特定の「ハッシュタグ」のツイートを、特定の「スプレッドシート」の「シート」に書き込む（全上書き）

- `#execute` の引数の意味は次の通り
  - 第二引数はツイートの絞り込み条件を与える
  - 第三引数はログに追加するハッシュを与える
  - 第四引数（キーワード引数）は `all_overwrite: true` でシートの全上書きをする
    - 指定しない場合には追記になるが、追記の場合はツイートやユーザーの公開状態が更新されない

```bash
$ $(which bundle) exec rails runner "GoogleSheetApi::WriteToResponseApiSheetByHashtag.new(spreadsheet_id: 'スプレッドシートのID', sheet_name: 'シート名').execute('対象のハッシュタグ（# は不要）', { remove_rt: true, not_by_gensosenkyo: true, end_at: Time.zone.parse('2021-06-11 01:00:00') }, {}, all_overwrite: true);"
```
