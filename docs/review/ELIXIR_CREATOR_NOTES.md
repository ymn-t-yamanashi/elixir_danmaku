# Elixir 作成者メモ

## 目的

この文書は、Elixir の作成者思想と設計背景を整理する。
コードレビューや設計判断のときに、言語の狙いを参照できるようにする。

## 本文

この文書は、Elixir の作成者が誰かと、Elixir にどのような設計思想があるかを、一次情報に近い資料ベースで整理するためのメモである。

## 作成者

- Elixir の作成者は `José Valim`
- Elixir は `2012 年` に `Plataformatec` 内の R&D プロジェクトとして始まった
- Elixir v1.0 は `2014 年 9 月` に公開された

## José Valim が Elixir で目指したもの

公式の `Development & Team` と José Valim 本人の `Elixir Design Goals` に基づくと、Elixir の核になる考え方は次の通りである。

### 1. 生産性

- Elixir の公式目標は、`maintainable and reliable software` を書くための `productive and extensible language` であること
- 単に短く書けることではなく、保守しやすく、長く運用しやすいことまで含めた生産性を重視している
- 言語だけでなく、`Mix`、`ExUnit`、ドキュメント、コンパイラ診断のようなツール群も重視している

### 2. 拡張性

- José Valim は設計目標として `compatibility, productivity and extensibility` を明示している
- Elixir は言語コアを小さく保ち、開発者が同じ仕組みを使って言語や DSL を拡張できることを重視している
- `if`、`case`、`try` なども特別扱いを増やすより、マクロを通じて扱える設計を採っている
- これは「言語を固定物として押し付ける」のではなく、ドメインに合わせて育てられることを意味する

### 3. Erlang VM / OTP との互換性

- Elixir は Erlang VM と既存エコシステムとの互換性を強く重視している
- Erlang のツールやライブラリを、変換コストなしで使えることが前提にある
- OTP と BEAM が持つ並行処理、分散、耐障害性を、そのまま活かす方向で設計されている

### 4. 信頼性と耐障害性

- Elixir の公式トップページでも、BEAM の `low-latency`, `distributed`, `fault-tolerant` な性質が強調されている
- Elixir は、障害が起こりうる本番環境を前提に、`supervisor` などで既知の安全な状態へ戻す考え方を土台にしている
- そのため、イベント駆動や長時間稼働するシステムと相性がよい

### 5. 小さく一貫したコア

- 公式の `Development & Team` では、v1.0 以降の言語開発は `compact and consistent core` に集中していると説明されている
- 言語機能は何でも追加するのではなく、次の基準で絞られている
- 言語自身の開発に必要か
- 言語に入れることでコミュニティ全体への効果を最大化できるか

### 6. 安定性と互換性を崩しにくい進化

- José Valim は v1.16 リリースで、Elixir チームは `tooling, documentation, and precise feedback` を改善しつつ、`the language stable and compatible` に保つと書いている
- 2023 年の型システム更新でも、まず `Elixir’s functional semantics` を表現できることを重視し、すぐに大きなユーザー向け変更を入れない姿勢が見える
- つまり、Elixir は急進的に壊す進化より、既存コードと開発体験の両立を重視する思想が強い

## 設計思想を短くまとめると

Elixir の思想は、次の 4 つに集約しやすい。

- `BEAM の強みを壊さずに使う`
- `小さく一貫した言語コアを保つ`
- `開発者が拡張しやすい仕組みを提供する`
- `保守性と信頼性を高める方向に進化する`

## 参考資料

- [Development & Team](https://elixir-lang.org/development.html)
- [Elixir Design Goals](https://elixir-lang.org/blog/2013/08/08/elixir-design-goals/)
- [The Elixir programming language](https://elixir-lang.org/)
- [Elixir v1.16 released](https://elixir-lang.org/blog/2023/12/22/elixir-v1-16-0-released/)
- [Type system updates: moving from research into development](https://elixir-lang.org/blog/2023/06/22/type-system-updates-research-dev/)
