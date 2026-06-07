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

## 初期構成

初期段階では次の 1 コンテナ構成とする。

- `app`

`app` コンテナに含めるもの:

- Erlang
- Elixir
- Phoenix 実行環境
- Node.js
- npm

DB は使わないため、DB コンテナは作らない。

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
- コンテナ外で `mix` を正本として実行しない
- 追加のコンテナは必要になるまで増やさない

## 今後の追加候補

- ホットリロード最適化
- アセットビルド専用補助設定
- 本番用コンテナ分離

ただし、初期段階では追加しない。
