# Elixir Web弾幕シューティング構成書

## 目的

この文書は `danmaku` の技術構成と責務分担を示す。
実装時の迷いを減らすため、Elixir 側と Babylon.js 側の役割をここで固定する。

## プロジェクト名

- プロジェクト名は `danmaku`
- Phoenix アプリ名は `danmaku`
- Elixir のトップレベルモジュール名は `Danmaku` を前提にする

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

## バージョン方針

採用バージョンの正本は [LIBRARY_VERSIONS.md](LIBRARY_VERSIONS.md) とする。

### Phoenix生成方針

- アプリ名: `danmaku`
- OTPアプリ名: `danmaku`
- ベースモジュール名: `Danmaku`
- DBは使わないため、生成時は `--no-ecto` を使う

生成コマンド:

以下の生成コマンドは Docker コンテナ内で実行する。

```bash
mix archive.install hex phx_new 1.8.7
mix phx.new danmaku --app danmaku --module Danmaku --no-ecto
```

詳細な依存バージョン一覧は [LIBRARY_VERSIONS.md](LIBRARY_VERSIONS.md) を参照する。

## 開発環境方針

- 開発環境の正本は Docker とする
- Windows では `Docker Desktop + WSL2 backend` を許容する
- macOS / Linux でも同じ Docker 構成で動かせる形を目指す
- `mix`, `node`, `npm`, `phoenix` の実行環境はホストではなくコンテナ側に寄せる
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
- クライアントへ送るゲーム状態の生成

### Phoenix Channelsの責務

- 入力イベント受信
- ゲーム状態の配信
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

- Elixir主導でゲーム状態を組み立てやすくする
- Babylon.js依存を薄い層に閉じ込める
- 後から必要な抽象だけ追加できるようにする

### 方式

- 初期段階の正本は `状態同期` とする
- Elixir側で正しいゲーム状態を作る
- Channel経由でクライアントへゲーム状態を送る
- クライアント側の薄い変換層が、受け取った状態を Babylon.js API へ反映する
- `描画命令同期` は初期の正本にせず、必要になった場合のみ限定用途で検討する

### 最小ラッパAPI案

ここでいうラッパAPIは、Elixir から直接 Babylon.js を呼ぶものではなく、Elixir 側の状態をクライアント側で Babylon.js へ写すための薄い変換層の責務を表す。

- `create_scene/1`
- `set_camera/1`
- `spawn_entity/2`
- `update_entity/2`
- `remove_entity/1`
- `play_effect/2`

### データ例

```elixir
%{
  player: %{kind: :ship, x: 120, y: 340, style: :player},
  enemies: [
    %{id: :enemy_1, kind: :enemy, x: 160, y: 80, style: :boss}
  ],
  bullets: [
    %{id: :bullet_1, kind: :bullet, x: 160, y: 120, style: :pink}
  ],
  effects: [
    %{kind: :boss_entry, x: 160, y: 80}
  ]
}
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

- `Danmaku.Game.Engine`: ゲームループ全体
- `Danmaku.Game.State`: ゲーム状態定義
- `Danmaku.Game.Entities.Player`: 自機ロジック
- `Danmaku.Game.Entities.Enemy`: 敵ロジック
- `Danmaku.Game.Entities.Bullet`: 弾ロジック
- `Danmaku.Game.Patterns`: 弾幕パターン生成
- `Danmaku.Game.Rendering.StateView`: クライアント送信用の状態整形
- `Danmaku.Game.Net`: クライアント送信用整形

### JavaScript側の責務分割案

- `bridge/channel.js`: Phoenix Channel接続
- `bridge/state.js`: Elixir由来ゲーム状態の解釈
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

## 今後追加を検討する文書

- `RENDERING_DSL.md`
- `PATTERNS.md`

## 最初の実装ステップ

1. `Phoenix` アプリ上で `Babylon.js` シーンを表示する
2. 固定カメラと簡単な背景を置く
3. 自機メッシュを1つ表示する
4. 入力送信と Elixir 側の位置更新をつなぎ、自機移動の反映速度を確認する
5. クライアント側で受け取ったゲーム状態を Babylon.js へ反映する
6. 敵1体を表示し、次に弾を追加する
7. 自機と弾の視認性、回避しやすさ、更新の滑らかさを確認する
8. HUDとエフェクトを順次追加する

## 実装上の注意

- 最初は3Dモデルを作り込みすぎない
- プリミティブ形状や単純な発光マテリアルで始める
- 弾幕の読みやすさを最優先する
- ラッパは必要になった抽象だけを追加する
