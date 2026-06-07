# Elixir Web弾幕シューティング構成書

## 全体方針

ゲームの正しい状態は常に `Elixir` 側が持つ。
クライアントは入力を送信し、受け取った状態を3D表示する。

- ゲーム性は2Dで管理する
- 表示だけを3D化する
- 当たり判定はElixir側の2Dロジックを正とする
- ブラウザ側は描画と最小限の補間に集中させる

## 推奨技術構成

- 開発環境: `Docker Compose`
- バックエンド: `Elixir + Phoenix`
- 通信: `Phoenix Channels / WebSocket`
- フロントエンド描画: `Babylon.js`
- データ保存: DBは使わない。ゲーム状態とスコアは実行中メモリで扱う

## 開発環境方針

- 開発環境の正本は Docker とする
- Windows では `Docker Desktop + WSL2 backend` を許容する
- macOS / Linux でも同じ Docker 構成で動かせる形を目指す
- `mix`, `node`, `phoenix` の実行環境はホストではなくコンテナ側に寄せる
- ブラウザ表示はホスト側で行い、アプリ本体はコンテナ内で動かす

### 初期コンテナ構成

- `app`: `Elixir + Erlang + Node` を含む開発用コンテナ

初期段階では DB コンテナは作らない。

## 2.5D方針

- Elixirは `x, y` の2D座標でゲーム状態を管理する
- クライアントは受け取った `x, y` を3D空間へ変換して表示する
- 例として `x -> x`, `y -> z` として配置し、`y` 軸は高さ演出に使う
- 3D表示は演出のために使い、ゲームルールそのものは複雑化しない

## Elixir主導アーキテクチャ

### Elixirの責務

- ゲームループ
- 自機、敵、弾、アイテムの座標更新
- 当たり判定
- スコア更新
- ボスフェーズ進行
- 弾幕パターン生成
- クライアントへ送る状態または描画命令の生成

### Phoenix Channelsの責務

- 入力イベント受信
- ゲーム状態または描画命令の配信
- 必要な同期境界の管理

### クライアントの責務

- キーボード入力の取得
- 入力状態の送信
- 受信した状態の保持
- 3Dシーン上での描画
- 更新間の最小限の補間
- HUD表示

## Babylon.js採用方針

`Babylon.js` は描画エンジンとして使い、ゲームルールは持たせすぎない。

### Babylon.jsで担当するもの

- 3Dシーン初期化
- カメラ
- ライト
- 自機、敵、弾の見た目
- 背景
- エフェクト
- UI重ね表示

### 3D演出の原則

- 視認性を最優先する
- 通常プレイ中はカメラを激しく動かしすぎない
- ボス登場やフェーズ切替で立体感を活かす
- 弾幕の読みやすさを壊す演出は避ける

## ElixirからBabylon.jsを触る最小ラッパ方針

Babylon.js全体をラップするのではなく、ゲームに必要な最小APIだけを定義する。

### 目的

- Elixir主導で表示命令を組み立てやすくする
- Babylon.js依存を薄い層に閉じ込める
- 後から必要な抽象だけ追加できるようにする

### 方式

- Elixir側で描画命令または描画状態を作る
- Channel経由でクライアントへ送る
- クライアント側の薄い変換層がBabylon.js APIへ反映する

### 最小ラッパAPI案

- `create_scene/1`
- `set_camera/1`
- `spawn_entity/2`
- `update_entity/2`
- `remove_entity/1`
- `play_effect/2`

### データ例

```elixir
[
  {:spawn_entity, :player, %{kind: :ship, x: 0, y: 0, style: :player}},
  {:update_entity, :player, %{x: 120, y: 340}},
  {:play_effect, :boss_entry, %{x: 160, y: 80}}
]
```

### 最初はラップしないもの

- 高度なマテリアル設定
- 複雑なポストプロセス
- 汎用物理演算
- エディタ的なシーン操作
- Babylon.js全APIの網羅

## Codexが理解しやすい構成方針

### 基本原則

- 1モジュール1責務に寄せる
- ゲームロジック、通信、描画変換を分離する
- 状態構造のネストを深くしすぎない
- 命名を省略しすぎない
- 早い段階からディレクトリ構成を安定させる

### 推奨ディレクトリイメージ

```text
lib/
  game/
    engine/
    entities/
    patterns/
    state/
    rendering/
    net/
  web/
    channels/
    controllers/
assets/
  js/
    game/
      scene/
      bridge/
      entities/
      ui/
```

### Elixir側の責務分割案

- `Game.Engine`: ゲームループ全体
- `Game.State`: ゲーム状態定義
- `Game.Entities.Player`: 自機ロジック
- `Game.Entities.Enemy`: 敵ロジック
- `Game.Entities.Bullet`: 弾ロジック
- `Game.Patterns`: 弾幕パターン生成
- `Game.Rendering.Commands`: 描画命令生成
- `Game.Net`: クライアント送信用整形

### JavaScript側の責務分割案

- `bridge/channel.js`: Phoenix Channel接続
- `bridge/commands.js`: Elixir由来コマンドの解釈
- `scene/createScene.js`: Babylon.jsシーン初期化
- `entities/player.js`: 自機表示更新
- `entities/enemy.js`: 敵表示更新
- `entities/bullet.js`: 弾表示更新
- `ui/hud.js`: HUD表示

### 避けたい構成

- 1ファイルにゲーム全体を書く
- Channel処理の中にゲームロジックを直接書く
- Babylon.js API呼び出しが全体に散らばる
- 重要ロジックを曖昧な `utils` に集める
- 命名規則が途中でぶれる

## 最初に作るとよい補助文書

- `GAME_SPEC.md`
- `RENDERING_DSL.md`
- `PATTERNS.md`
- `DOCKER_SETUP.md`

## 最初の実装ステップ

1. `Phoenix` アプリ上で `Babylon.js` シーンを表示する
2. 固定カメラと簡単な背景を置く
3. 自機メッシュを1つ表示する
4. Elixir側で `spawn_entity` と `update_entity` 相当の最小命令を作る
5. クライアント側でその命令をBabylon.jsへ反映する
6. 敵1体を表示し、次に弾を追加する
7. HUDとエフェクトを順次追加する

## 実装上の注意

- 最初は3Dモデルを作り込みすぎない
- プリミティブ形状や単純な発光マテリアルで始める
- 弾幕の読みやすさを最優先する
- ラッパは必要になった抽象だけを追加する
