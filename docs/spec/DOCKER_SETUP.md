# Dockerセットアップ方針

## 目的

この文書は、`danmaku` を Docker 前提で開発するための環境ルールを定める。
Windows, macOS, Linux のどれでも同じ手順で進められることを重視する。

## 本文

この文書は、このプロジェクトを Docker 前提で開発するための基本方針を定義する。
Windows, macOS, Linux のいずれでも、できるだけ同じ手順で開発を始められる状態を目指す。

関連文書:

- [PLAN.md](../project/PLAN.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [CODEX_RULES.md](../rules/CODEX_RULES.md)

## 基本方針

- 開発環境の正本は Docker とする
- Windows では `Docker Desktop` を前提にする
- ホスト OS には必須ツールを増やしすぎない
- `mix` と `node` の主要コマンドはコンテナ内で実行する
- ブラウザだけはホスト側で開く
- ブラウザ確認にはコンテナ内の `Chromium` を使う
- ビルドと実行は Docker コンテナ内でのみ行う
- ホスト環境でのビルドと実行は禁止する

## Windows利用時の注意

- Windows で bind mount したホストファイルは、コンテナ側の権限変更や実行属性変更で不安定になることがある
- コンテナ側の実行ユーザーは、`.env` の固定値を基準に合わせる
- コンテナ内でホスト側ファイルの所有者や権限を無理に変更しない
- ファイル操作はできるだけ編集対象の保存だけに限定し、権限修正前提の運用にしない
- 権限や改行の差異が問題になった場合は、マウント方法の見直しを優先する

## ユーザー整合方針

- Docker の実行ユーザーは `.env` で渡す固定値を基準にする
- Windows ではホストのログインユーザーを Linux の UID/GID に直接変換しない
- bind mount したファイルの読み書きで権限差が出ない構成を優先する
- UID/GID が揃えられない場合は、ホスト側ファイルの権限変更ではなく、コンテナ側の実行方法を見直す
- `deps`、`_build`、`assets/node_modules` は named volume に逃がし、Windows の bind mount 負荷を減らす
- 起動時に entrypoint で named volume の所有者を初回だけ `app` に揃える
- `MIX_ENV` は用途ごとに切り替え、開発時は `dev`、検証時は `test` を使う

## 実装ルート

- `docker-compose.yml` の `app` サービスは、`Dockerfile` の entrypoint で `gosu app` に切り替える
- `.env` の既定値は `LOCAL_UID=1000` と `LOCAL_GID=1000` とする
- Windows ではホストユーザー名に依存せず、この固定値を開発用の標準とする
- ホスト側ファイルの所有者変更ではなく、コンテナ側の実行ユーザー調整で権限問題を避ける

## 初期構成

初期段階では次の 1 コンテナ構成とする。

- `app`

この `app` は `danmaku` の開発用コンテナとする。

`app` コンテナに含めるもの:

- Erlang
- Elixir
- Phoenix 実行環境
- Node.js
- npm
- Chromium

DB は使わないため、DB コンテナは作らない。

## バージョン固定

採用バージョンの正本は [LIBRARY_VERSIONS.md](LIBRARY_VERSIONS.md) とする。

Docker ベースイメージは次を前提にする。

```dockerfile
FROM elixir:1.19.5-otp-28
```

Phoenix アプリ生成は次を前提にする。

以下の生成コマンドは Docker コンテナ内で実行する。

```bash
mix archive.install hex phx_new 1.8.7
mix phx.new danmaku --app danmaku --module Danmaku --no-ecto
```

## コンテナの役割

### `app`

- `mix` コマンド実行
- Phoenix サーバ起動
- フロントエンド依存のインストール
- ハーネス実行

## 実行方針

- ソースコードは bind mount でコンテナに渡す
- 開発中の編集はホスト側エディタで行う
- アプリはコンテナ内で起動する
- ブラウザはホスト側から `localhost` に接続する

## ハーネスとの関係

[HARNESS_SPEC.md](HARNESS_SPEC.md) で定義した次のコマンドは、Docker コンテナ内で実行する前提とする。

- `mix format`
- `mix compile`
- `mix test`
- `mix credo`
- `mix check`

## 初期に必要なファイル

- `Dockerfile`
- `docker-compose.yml`
- 必要なら `.dockerignore`

## 目標

- 初回セットアップ手順を短くする
- 別 OS でも再現しやすくする
- Codex が開発環境を一意に理解できるようにする
- ホスト依存の差分を減らす

## 初期ルール

- ホストに Elixir を必須としない
- ホストに Node.js を必須としない方針を優先する
- コンテナ外で `mix` を実行しない
- `mix`, `node`, `npm`, `phoenix` は Docker コンテナ内でのみ実行する
- 追加のコンテナは必要になるまで増やさない

## 今後の追加候補

- ホットリロード最適化
- アセットビルド専用補助設定
- 本番用コンテナ分離

ただし、初期段階では追加しない。
