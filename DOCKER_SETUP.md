# Dockerセットアップ方針

## 目的

この文書は、このプロジェクトを Docker 前提で開発するための基本方針を定義する。
Windows, macOS, Linux のいずれでも、できるだけ同じ手順で開発を始められる状態を目指す。

関連文書:

- [PLAN.md](PLAN.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [CODEX_RULES.md](CODEX_RULES.md)

## 基本方針

- 開発環境の正本は Docker とする
- Windows では `Docker Desktop + WSL2 backend` を許容する
- ホスト OS には必須ツールを増やしすぎない
- `mix` と `node` の主要コマンドはコンテナ内で実行する
- ブラウザだけはホスト側で開く
- ビルドと実行は Docker コンテナ内でのみ行う
- ホスト環境でのビルドと実行は禁止する

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

DB は使わないため、DB コンテナは作らない。

## バージョン固定

- `Erlang/OTP`: `28`
- `Elixir`: `1.19.5`
- `phx_new`: `1.8.7`
- `Node.js`: `22.22.3`
- `npm`: `10.9.8`

Docker ベースイメージは次を前提にする。

```dockerfile
FROM elixir:1.19.5-otp-28
```

Phoenix アプリ生成は次を前提にする。

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
