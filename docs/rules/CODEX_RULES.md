# Codexガードレール

## 目的

この文書は、このプロジェクトで Codex が守るべき作業ルールを定義する。
対象はコード実装、ファイル編集、仕様更新、検証手順、技術判断である。

プロジェクト名は `danmaku` とする。

## 基本方針

- Codex は仕様書を優先して実装する
- Codex は曖昧な推測でプロジェクト方針を変更しない
- Codex は自信が無い内容を勝手に判断しない
- Codex は小さい変更単位で進める
- Codex は変更後に必ず定義済みハーネスで確認する

## 優先する文書

Codex は次の順で文書を参照して判断する。

1. [PLAN.md](../project/PLAN.md)
2. [ARCHITECTURE.md](../spec/ARCHITECTURE.md)
3. [GAME_SPEC.md](../spec/GAME_SPEC.md)
4. [DESIGN_SPEC.md](../spec/DESIGN_SPEC.md)
5. [HARNESS_SPEC.md](../spec/HARNESS_SPEC.md)
6. [ELIXIR_CODING_RULES.md](ELIXIR_CODING_RULES.md)
7. [GAME_REVIEW_PROFILE.md](../review/GAME_REVIEW_PROFILE.md)
8. [REVIEW_SYSTEM.md](../review/REVIEW_SYSTEM.md)

詳細な索引は [docs/README.md](docs/README.md) を参照する。

仕様が衝突した場合は、実装前に確認を取る。

## ゲーム設計上の固定ルール

- ゲーム性は2Dで実装する
- 見た目は3D表示の `2.5D` とする
- 正しいゲーム状態は Elixir 側が持つ
- 当たり判定は Elixir 側の2Dロジックを正とする
- Babylon.js は描画専用とする
- ブラウザ側は入力、描画、最小限の補間だけを担当する

## 技術選定の固定ルール

- バックエンドは `Elixir + Phoenix`
- リアルタイム通信は `Phoenix Channels`
- フロントエンド描画は `Babylon.js`
- 開発環境の正本は Docker とする
- ビルドと実行は Docker コンテナ内で行う
- ホスト環境でのビルドと実行を禁止する
- `mix`, `node`, `npm`, `phoenix` は Docker コンテナ内でのみ実行する
- DBは使わない
- ゲーム状態とスコアは実行中メモリで扱う
- 永続保存を前提にした実装は初期段階で入れない

## 音のルール

- 音はゲーム仕様に含めてよい
- ただし、音の有無でゲーム進行が破綻する設計にしない
- 音がなくてもゲームループと判定は成立するようにする

## 構成ルール

- 1モジュール1責務を守る
- ゲームロジック、通信、描画変換を分離する
- Babylon.js API 呼び出しをアプリ全体に散らさない
- 重要ロジックを曖昧な `utils` に集めない
- 命名は省略しすぎない
- Elixir コードは [ELIXIR_CODING_RULES.md](ELIXIR_CODING_RULES.md) に従う

## Codexが編集時に守るルール

- 既存ファイルの責務を崩さない
- 無関係なリファクタを混ぜない
- 1回の変更で目的を増やしすぎない
- 必要がない限り新しい抽象化を増やさない
- 仕様変更を伴う場合は仕様書も更新する
- レビュー運用は [REVIEW_SYSTEM.md](../review/REVIEW_SYSTEM.md) に従う
- ユーザーが `レビューして` と依頼した場合は、原則として [REVIEW_SYSTEM.md](../review/REVIEW_SYSTEM.md) に従ってレビューする
- レビュー結果は必ず 4 人の会話形式で示し、最後に整理レビュー担当が要約する

## Codexが避けること

- 勝手に DB を追加する
- 勝手に別ライブラリへ乗り換える
- 勝手にホスト依存の開発手順を正本にする
- ゲームロジックを Babylon.js 側へ移す
- 当たり判定を3D形状ベースへ変える
- shell script 前提の複雑な運用を増やす
- 仕様書と異なる見た目や挙動を黙って実装する

## ハーネス運用ルール

Codex は [HARNESS_SPEC.md](../spec/HARNESS_SPEC.md) に従う。

変更後の確認コマンドは次に固定する。

- `mix format`
- `mix compile`
- `mix test`
- `mix credo`
- `mix check`

コード変更後に最初に優先する総合確認コマンドは `mix check` とする。

## デザイン実装ルール

- デザイン実装は [DESIGN_SPEC.md](../spec/DESIGN_SPEC.md) に忠実に行う
- 視認性を最優先する
- 背景より弾と自機の可読性を優先する
- UI をモダンWebアプリ風に単純化しない
- 東方風の幻想性と密度感を保つ
- ゲーム体験や見た目のレビュー時は [GAME_REVIEW_PROFILE.md](../review/GAME_REVIEW_PROFILE.md) も参照する

## 仕様更新ルール

- 計画変更は `PLAN.md`
- 技術構成変更は `ARCHITECTURE.md`
- ゲーム内容変更は `GAME_SPEC.md`
- 見た目変更は `DESIGN_SPEC.md`
- 開発コマンド変更は `HARNESS_SPEC.md`

Codex は変更対象に応じて、対応する文書を更新する。
Codex は文書を更新したとき、関連する他の文書との整合性と重複を確認する。
整合性が崩れる場合は、必要な文書もあわせて更新する。

## 文書言語ルール

- Markdown 文書は原則として日本語で記述する
- ただし、コード、コマンド、ファイル名、識別子、外部仕様名は原文表記を優先する
- 既存文書を更新するときは、同じ文書内で言語方針を混在させない
- 例外が必要な場合は、その文書内で理由を明記する

## 実装前の判断ルール

Codex は次の順で判断する。

1. 既存仕様書に答えがあるか確認する
2. 既存仕様書に従って最小変更で実装する
3. 仕様書に答えがない場合のみ、最小の仮定を置く
4. 仮定が大きい場合は実装前に確認する

## 完了条件

Codex は次を満たしたときに、その作業を完了とみなす。

- 依頼された内容がファイルまたはコードに反映されている
- 関連仕様書が必要に応じて更新されている
- 実行可能な確認を済ませている
- 未確認事項がある場合は明示している

## 結論

このプロジェクトで Codex は、仕様書駆動、Elixir主導、2D判定、Babylon.js描画、DBなし、`mix check` 重視の方針を守る。
この文書に反する実装判断は行わない。
