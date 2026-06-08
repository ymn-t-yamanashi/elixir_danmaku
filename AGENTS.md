# プロジェクト指示

プロジェクト名は `danmaku` とする。

変更を行う前に、次のファイルをこの順番で読むこと。

1. [CODEX_RULES.md](CODEX_RULES.md)
2. [PLAN.md](PLAN.md)
3. [ARCHITECTURE.md](ARCHITECTURE.md)
4. [GAME_SPEC.md](GAME_SPEC.md)
5. [DESIGN_SPEC.md](DESIGN_SPEC.md)
6. [HARNESS_SPEC.md](HARNESS_SPEC.md)
7. [ELIXIR_CODING_RULES.md](ELIXIR_CODING_RULES.md)
8. [ELIXIR_CREATOR_NOTES.md](ELIXIR_CREATOR_NOTES.md)
9. [GAME_REVIEW_RULES.md](GAME_REVIEW_RULES.md)
10. [TECH_SECRETARY_PROFILE.md](TECH_SECRETARY_PROFILE.md)

各文書の役割:

- [CODEX_RULES.md](CODEX_RULES.md): Codex が守る固定ルール
- [PLAN.md](PLAN.md): プロジェクト全体の目的と基本方針
- [ARCHITECTURE.md](ARCHITECTURE.md): 技術構成と責務分担
- [GAME_SPEC.md](GAME_SPEC.md): ゲーム内容と挙動の仕様
- [DESIGN_SPEC.md](DESIGN_SPEC.md): 見た目と演出の仕様
- [HARNESS_SPEC.md](HARNESS_SPEC.md): 開発・検証コマンドのルール
- [ELIXIR_CODING_RULES.md](ELIXIR_CODING_RULES.md): Elixir の書き方ルール
- [ELIXIR_CREATOR_NOTES.md](ELIXIR_CREATOR_NOTES.md): Elixir の作成者と設計思想の整理
- [GAME_REVIEW_RULES.md](GAME_REVIEW_RULES.md): ゲーム体験レビューの観点
- [TECH_SECRETARY_PROFILE.md](TECH_SECRETARY_PROFILE.md): 技術が分かる右腕の人物像
- [LIBRARY_VERSIONS.md](LIBRARY_VERSIONS.md): 採用バージョンの正本
- [DOCKER_SETUP.md](DOCKER_SETUP.md): Docker 前提の開発環境ルール
- [ROADMAP.md](ROADMAP.md): 機能を広げる順番
- [WATERFALL_PLAN.md](WATERFALL_PLAN.md): ウォーターフォール工程の正本
- [STATUS_BOARD.md](STATUS_BOARD.md): 現在地と次の作業の正本
- [FIRST_MILESTONE.md](FIRST_MILESTONE.md): 最初の実装到達点
- [RISK_NOTES.md](RISK_NOTES.md): 破綻しやすい点と注意事項

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

検証ルール:

- コード変更後は `mix check` を優先して実行すること
