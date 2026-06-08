# プロジェクト指示

プロジェクト名は `danmaku` とする。

変更を行う前に、次のファイルをこの順番で読むこと。

1. [CODEX_RULES.md](docs/rules/CODEX_RULES.md)
2. [PLAN.md](docs/project/PLAN.md)
3. [ARCHITECTURE.md](docs/spec/ARCHITECTURE.md)
4. [LIBRARY_VERSIONS.md](docs/spec/LIBRARY_VERSIONS.md)
5. [DOCKER_SETUP.md](docs/spec/DOCKER_SETUP.md)
6. [GAME_SPEC.md](docs/spec/GAME_SPEC.md)
7. [DESIGN_SPEC.md](docs/spec/DESIGN_SPEC.md)
8. [HARNESS_SPEC.md](docs/spec/HARNESS_SPEC.md)
9. [ELIXIR_CODING_RULES.md](docs/rules/ELIXIR_CODING_RULES.md)
10. [ELIXIR_CREATOR_PROFILE.md](docs/review/ELIXIR_CREATOR_PROFILE.md)
11. [GAME_REVIEW_PROFILE.md](docs/review/GAME_REVIEW_PROFILE.md)
12. [REVIEW_SYSTEM.md](docs/review/REVIEW_SYSTEM.md)

整理された文書一覧は [docs/README.md](docs/README.md) を参照する。

主要文書の役割:

- `CODEX_RULES.md`: Codex が守る固定ルール
- `STATUS_BOARD.md`: 現在地と次の作業の正本
- `REVIEW_SYSTEM.md`: レビュー体制とサブエージェント運用の正本
- `HARNESS_SPEC.md`: 開発・検証コマンドのルール
- `PLAN.md`: プロジェクト全体の目的と基本方針

基本ルール:

- `CODEX_RULES.md` に従うこと
- ゲームロジックは Elixir 側に置くこと
- Babylon.js は描画専用として扱うこと
- データベースを追加しないこと
- ビルドと実行は Docker で行うこと
- ホスト環境でのビルドと実行を禁止する
- ハーネスは `HARNESS_SPEC.md` のルールに従うこと
- 文書を更新したときは、他の文書との整合性と重複を確認すること
- 現在地は `STATUS_BOARD.md` を唯一の正本として扱うこと
- 変更は小さく責務を絞ること
- 自信が無い内容は、勝手に判断しないこと
- ユーザーが `レビューして` と依頼した場合は、`REVIEW_SYSTEM.md` に従ってレビューすること
- レビュー結果は必ず 4 人の会話形式にし、最後は整理レビュー担当が要約すること

検証ルール:

- コード変更後は `mix check` を優先して実行すること
