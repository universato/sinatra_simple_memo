# Sinatra Simple Memo

## 最初に

RubyのSinatraの演習のために作ったメモアプリです。

## バージョン

Ruby 2.7

## セットアップ方法

### DB構築

本メモアプリは、DBにPostgreSQLを使用しています。
PosgreSQLが入っている前提で、構築方法を以下に記載します。

#### DBのための環境変数の設定

`.env`ファイルを作成し、以下のように記載します。

```rb
HOST=localhost
PORT=5432
DB_NAME=sinatra_simple_memo_db
USER=uni
```

ユーザー名を除いて、デフォルトで上記の設定です。

#### DBのテーブルの構築

テーブルは、下記のように作ります。

```sql
drop table if exists memos;
create table memos (
  id serial not null,
  title text not null,
  detail text,
  primary key (id),
  unique (title)
);
```

(detailをbodyに変えたいな)

### アプリの立ち上げ方法

以下、Rubyが入っている前提です。
必要なGemのために、次のコマンドを打ちます。

```sh
bundle install
```

また、`app.rb`を動かします。

```sh
ruby app.rb -e development
```

### 注意

URLに`/`が記号として使われるため、
本アプリではURLにメモのタイトルを使っている関係上、
メモのタイトルに`/`という文字は使えません。
タイトルに`/`の入力があると、タイトルで`/`は削除されます。

その他、`<script>`という文字列も削除されます。
また、`new`という文字列は単体でタイトルには使えません。
