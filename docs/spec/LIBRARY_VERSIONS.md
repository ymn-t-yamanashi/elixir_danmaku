# ライブラリ採用バージョン

## 目的

この文書は、`danmaku` で採用するツールチェーンと主要ライブラリのバージョンを固定する。
Docker 前提の開発で使うことを前提にする。

## 本文

この文書は、`danmaku` で採用するツールチェーンと主要ライブラリのバージョンを固定するための一覧である。
Docker 前提の開発環境で使うことを前提にする。

関連文書:

- [ARCHITECTURE.md](ARCHITECTURE.md)
- [DOCKER_SETUP.md](DOCKER_SETUP.md)
- [CODEX_RULES.md](../rules/CODEX_RULES.md)

## ツールチェーン

- `Erlang/OTP`: `28.1`
- `Elixir`: `1.19.5`
- `Node.js`: `22.22.3`
- `npm`: `10.9.8`
- `phx_new`: `1.8.7`

## Elixir依存

- `phoenix`: `~> 1.8.7`
- `bandit`: `~> 1.11`
- `phoenix_html`: `~> 4.3`
- `phoenix_live_view`: `~> 1.1`
- `phoenix_live_reload`: `~> 1.6`
- `jason`: `~> 1.4`
- `telemetry_metrics`: `~> 1.1`
- `telemetry_poller`: `~> 1.3`
- `esbuild`: `~> 0.10`
- `credo`: `~> 1.7`

## JavaScript依存

- `@babylonjs/core`: `8.26.0`
- `@babylonjs/gui`: `8.26.0`
- `@babylonjs/loaders`: `8.26.0`

## 初期方針

- DB関連ライブラリは追加しない
- Ecto関連ライブラリは追加しない
- Tailwindは初期導入しない
- 依存追加は必要になってから行う

## 補足

- Phoenix アプリ生成は `--no-ecto` を使う
- 最終的な厳密固定は `mix.lock` と `package-lock.json` に委ねる
- この文書は「採用方針の固定」に使う
