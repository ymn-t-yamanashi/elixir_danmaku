# Elixir開発ハーネス仕様書

## 目的

この文書でいう「ハーネス」は、Elixirプロジェクトの開発用コマンド群を指す。
対象はゲームロジックではない。
対象は `mix format`、`mix test`、`mix compile`、`mix check` のような、開発時に繰り返し実行するコマンドである。

## このプロジェクトでの定義

ハーネスは次の 5 コマンドで構成する。

- `mix format`
- `mix compile`
- `mix test`
- `mix credo`
- `mix check`

初期段階では、この 5 つ以外をハーネスに含めない。

## 必須コマンド

### `mix format`

役割:

- Elixirコードを整形する

実行内容:

- `.formatter.exs` の設定に従って `lib/`, `test/`, `config/`, `mix.exs` を整形する

用途:

- 開発中の通常整形
- コミット前の整形

### `mix compile`

役割:

- コンパイルが通ることを確認する

実行内容:

- プロジェクト全体をコンパイルする

用途:

- 編集直後の最低限確認
- `mix check` の一部

### `mix test`

役割:

- テストを実行する

実行内容:

- `test/` 配下の ExUnit テストを実行する

用途:

- ロジック変更後の確認
- `mix check` の一部

### `mix credo`

役割:

- Elixir のコーディングルールと可読性を確認する

実行内容:

- `mix credo --strict`

用途:

- Elixir らしい書き方になっているかの確認
- 可読性の低い実装や不自然な記述の検出
- `mix check` の一部

### `mix check`

役割:

- 日常開発で使う総合確認コマンド

実行順:

1. `mix format --check-formatted`
2. `mix compile`
3. `mix test`
4. `mix credo --strict`

成功条件:

- 4ステップすべてが成功すること

失敗条件:

- いずれか 1 ステップでも失敗したら失敗とする

## `mix check` の定義方法

`mix check` は `mix.exs` の aliases で定義する。

初期定義はこれに固定する。

```elixir
defp aliases do
  [
    check: [
      "format --check-formatted",
      "compile",
      "test",
      "credo --strict"
    ]
  ]
end
```

初期段階では `Mix.Tasks.Check` のような独自タスクは作らない。

## 採用しないもの

初期段階では次を採用しない。

- `mix ci`
- `mix dev.setup`
- `mix dev.reset`
- `mix lint`
- `mix dialyzer`
- shell script によるラッパ

理由:

- まだプロジェクトが小さいため
- ハーネスの責務を増やしすぎないため
- Codex が最初に理解する対象を最小化するため

## 将来追加してよい条件

次の条件を満たしたときだけ、新しいハーネスコマンドを追加してよい。

- 同じ手順を人間またはCodexが3回以上繰り返した
- その手順が2コマンド以上の組み合わせになっている
- 追加後の役割がコマンド名だけで明確に伝わる

## 将来追加できる候補

この文書では候補だけ定義する。
今は実装しない。

- `mix ci`
- `mix dev.setup`
- `mix dev.reset`
- `mix game.preview`

## 命名規則

- 日常総合確認は `check`
- 開発補助は `dev.*`
- ゲーム補助は `game.*`
- 検証補助は `verify.*`

`run-all` や `full` のような曖昧な名前は禁止する。

## Codex向けの明確なルール

- Codex がコード変更後に最初に実行する確認コマンドは `mix check`
- 整形だけしたい場合は `mix format`
- コンパイル確認だけしたい場合は `mix compile`
- テストだけ回したい場合は `mix test`
- コーディングルール確認だけしたい場合は `mix credo`

この優先順位を固定する。

## ディレクトリ前提

ハーネスは Elixir プロジェクトルートで実行する。

対象ディレクトリは次に固定する。

- `lib/`
- `test/`
- `config/`
- `mix.exs`

## DBに関するルール

このプロジェクトでは DB を使わない。
そのため、ハーネスにも以下を含めない。

- `ecto.create`
- `ecto.migrate`
- `ecto.reset`

## 音に関するルール

音はゲーム仕様として使う。
ただし、ハーネスには音声確認コマンドを含めない。
音関連の確認は初期ハーネスの責務外とする。

## 初期実装順

1. `.formatter.exs` を作る
2. `mix format` を通す
3. `mix test` が実行できる最小構成を作る
4. `mix credo` を実行できるように依存を追加する
5. `mix.exs` に `check` alias を追加する
6. `mix check` が通る状態を作る

## 完了条件

初期ハーネスの完了条件は次の 3 点である。

- `mix format` が実行できる
- `mix test` が実行できる
- `mix credo` が実行できる
- `mix check` が aliases 経由で実行できる

## 結論

このプロジェクトの Elixir ハーネスは、初期段階では次の 5 コマンドのみで構成する。

- `mix format`
- `mix compile`
- `mix test`
- `mix credo`
- `mix check`

`mix check` は aliases で定義し、実行順は `format --check-formatted -> compile -> test -> credo --strict` に固定する。
