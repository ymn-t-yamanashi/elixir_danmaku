# Elixir開発ハーネス

## 目的

この文書は、`danmaku` の開発・検証コマンドのルールを定める。
Docker 内での実行を前提に、再現性のある手順だけを扱う。

## 定義

このプロジェクトでの「ハーネス」は、Codex と人間が共通で使う開発・検証コマンド群を指す。
ゲームロジック検証用の独自ランナーは指さない。

## 対象コマンド

- `mix format`
- `mix compile`
- `mix test`
- `mix credo`
- `mix check`
- `mix coveralls`

初期段階では、この 6 つ以外をハーネスに含めない。

## 役割

### `mix format`

- コード整形を行う

### `mix compile`

- コンパイル確認を行う

### `mix test`

- テスト実行を行う
- 実行時は `MIX_ENV=test` を使う

### `mix coveralls`

- テストカバレッジを測定する
- 既定の合格基準は `95%` 以上とする
- 可能であれば `100%` を維持する
- 実行時は `MIX_ENV=test` を使う

### `mix credo`

- Elixir のコーディングルールと可読性を確認する
- 実行は `mix credo --strict` とする

### `mix check`

- 日常開発で使う総合確認コマンド

実行順は次に固定する。

1. `mix format --check-formatted`
2. `mix compile`
3. `mix test`
4. `mix credo --strict`

## 実装方法

`mix check` は `mix.exs` の aliases で定義する。
初期定義は次に固定する。

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

## Codex運用ルール

- Codex がコード変更後に最初に実行する総合確認は `mix check`
- 整形だけ確認したいときは `mix format`
- コンパイルだけ確認したいときは `mix compile`
- テストだけ確認したいときは `mix test`
- カバレッジを確認したいときは `mix coveralls`
- `mix test` と `mix coveralls` は `MIX_ENV=test` で実行する
- コーディングルールだけ確認したいときは `mix credo`

## Docker前提

このプロジェクトでは、ハーネス対象コマンドは Docker コンテナ内で実行する前提とする。
ホスト環境での `mix` 実行を禁止する。
ビルド、テスト、整形、Lint を含む全ハーネスコマンドは Docker コンテナ内でのみ実行する。

## 含めないもの

初期段階では次を含めない。

- `mix ci`
- `mix dev.setup`
- `mix dev.reset`
- `mix dialyzer`
- shell script ラッパ

## 完了条件

初期ハーネスが成立している条件は次の 5 点である。

- `mix format` が実行できる
- `mix test` が実行できる
- `mix credo --strict` が実行できる
- `mix check` が aliases 経由で実行できる
- `mix coveralls` が実行できる

テストカバレッジの運用基準は次の通りとする。

- `mix coveralls` で `95%` 以上を維持する
- 可能であれば `100%` を維持する

## 結論

このプロジェクトの Codex 向けハーネスは、`mix format`, `mix compile`, `mix test`, `mix credo`, `mix check`, `mix coveralls` の 6 つで構成する。
Codex はコード変更後、まず `mix check` を実行する。
