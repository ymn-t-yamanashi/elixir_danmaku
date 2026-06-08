# レビュー文書

レビュー体制と観点に関する文書の索引。

## 命名ルール

- ファイル名は原則として `役割名_種別.md` でそろえる
- `役割名` と `種別` は英語の大文字スネークケースで書く
- `種別` は次を基本にする
  - `PROFILE`: 役割や人物像の説明
  - `SYSTEM`: 運用や体制の説明
  - `README`: 配下文書の索引
- ハイフンは使わない
- 例: `GAME_REVIEW_PROFILE.md`, `ELIXIR_CREATOR_PROFILE.md`, `REVIEW_SYSTEM.md`

## 本文フォーマット

### `PROFILE`

- `# タイトル`
- `## 目的`
- `## 本文`
- `## 何を見るか` または `## この役割に求めるもの`
- `## 使い方` または `## レビューでの使い方`
- `## 参考資料`

### `SYSTEM`

- `# タイトル`
- `## 目的`
- `## 本文`
- `## 基本方針`
- `## 役割分担`
- `## 主担当エージェントの役割`
- `## サブエージェントに渡す入力`
- `## 依頼テンプレート`
- `## 参考` または `## 補足`

### 共通ルール

- 見出しの順番を揃える
- 同じ意味の見出しを文書ごとに増やさない
- 1 つの文書で、目的と本文の役割を分ける
- 参考情報は最後に寄せる
- 具体例が必要な場合だけ本文の後ろに入れる

- [`REVIEW_SYSTEM.md`](REVIEW_SYSTEM.md)
- [`GAME_REVIEW_PROFILE.md`](GAME_REVIEW_PROFILE.md)
- [`ELIXIR_CREATOR_PROFILE.md`](ELIXIR_CREATOR_PROFILE.md)
- [`DOC_REVIEW_PROFILE.md`](DOC_REVIEW_PROFILE.md)
- [`CODEX_REVIEW_PROFILE.md`](CODEX_REVIEW_PROFILE.md)
