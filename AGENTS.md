# プロジェクト指示

プロジェクト名は `danmaku` とする。

変更を行う前に、次のファイルをこの順番で読むこと。

1. [CODEX_RULES.md](CODEX_RULES.md)
2. [PLAN.md](PLAN.md)
3. [ARCHITECTURE.md](ARCHITECTURE.md)
4. [GAME_SPEC.md](GAME_SPEC.md)
5. [DESIGN_SPEC.md](DESIGN_SPEC.md)
6. [HARNESS_SPEC.md](HARNESS_SPEC.md)

基本ルール:

- `CODEX_RULES.md` に従うこと
- ゲームロジックは Elixir 側に置くこと
- Babylon.js は描画専用として扱うこと
- データベースを追加しないこと
- ハーネスは `HARNESS_SPEC.md` のルールに従うこと
- 変更は小さく責務を絞ること

検証ルール:

- コード変更後は `mix check` を優先して実行すること
