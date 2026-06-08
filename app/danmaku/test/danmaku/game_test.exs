defmodule Danmaku.GameTest do
  use ExUnit.Case, async: true

  alias Danmaku.Game
  alias Danmaku.Game.Entity

  describe "new/0" do
    test "初期状態を返す" do
      state = Game.new()

      assert state.tick == 0
      assert state.player.kind == :player
      assert state.enemy.kind == :enemy
      assert state.bullets == []
    end

    test "プレイヤーと敵の初期エンティティを直接生成できる" do
      assert Entity.player().kind == :player
      assert Entity.enemy().kind == :enemy
    end
  end

  describe "step/2" do
    test "入力に応じて自機が移動する" do
      state = Game.new()
      state = %{state | player: %{state.player | x: 100.0, y: 200.0}}

      next_state = Game.step(state, %{move: %{x: 1, y: -1}})

      assert next_state.player.x == 106.0
      assert next_state.player.y == 194.0
      assert next_state.tick == 1
    end

    test "画面外に出る方向の入力でも端で止まる" do
      state = Game.new()
      state = %{state | player: %{state.player | x: 319.0, y: 10.0}}

      next_state = Game.step(state, %{move: %{x: 1, y: -1}})

      assert next_state.player.x == 312.0
      assert next_state.player.y == 8.0
    end

    test "平坦なx y形式の入力も受け取れる" do
      state = Game.new()

      next_state = Game.step(state, %{x: 0, y: 0})

      assert next_state.player.x == state.player.x
      assert next_state.player.y == state.player.y
    end

    test "一定間隔で敵弾を1つ生成する" do
      state = %{Game.new() | tick: 29}

      next_state = Game.step(state, %{})

      assert length(next_state.bullets) == 1
      [bullet] = next_state.bullets
      assert bullet.kind == :bullet
      assert bullet.id == {:enemy_bullet, 30}
      assert bullet.y > next_state.enemy.y
    end

    test "弾は下方向へ進む" do
      bullet = Entity.bullet(:bullet_1, 100.0, 100.0, 8.0)
      state = %{Game.new() | bullets: [bullet]}

      next_state = Game.step(state, %{})

      [moved_bullet] = next_state.bullets
      assert moved_bullet.y == 108.0
    end
  end

  describe "snapshot/1" do
    test "画面描画用の情報を取り出せる" do
      snapshot = Game.snapshot(Game.new())

      assert snapshot.tick == 0
      assert snapshot.player.kind == :player
      assert snapshot.enemy.kind == :enemy
      assert snapshot.bullets == []
    end
  end
end
