defmodule Danmaku.Game do
  @moduledoc """
  最小のゲーム状態更新を担当する。
  """

  alias Danmaku.Game.Entity
  alias Danmaku.Game.State

  @bullet_interval 30
  @bullet_speed 8.0

  def new do
    %State{}
  end

  def step(%State{} = state, input \\ %{}) do
    state
    |> move_player(input)
    |> maybe_spawn_enemy_bullet()
    |> advance_bullets()
    |> increment_tick()
  end

  def move(%State{} = state, input \\ %{}) do
    move_player(state, input)
  end

  def snapshot(%State{} = state) do
    %{
      tick: state.tick,
      width: state.width,
      height: state.height,
      player: state.player,
      enemy: state.enemy,
      bullets: state.bullets
    }
  end

  defp move_player(%State{} = state, input) do
    {dx, dy} = input_move(input)
    %{state | player: Entity.move(state.player, dx, dy, bounds(state))}
  end

  defp maybe_spawn_enemy_bullet(%State{} = state) do
    if rem(state.tick + 1, @bullet_interval) == 0 do
      bullet =
        Entity.bullet(
          {:enemy_bullet, state.tick + 1},
          state.enemy.x,
          state.enemy.y + 18.0,
          @bullet_speed
        )

      %{state | bullets: [bullet | state.bullets]}
    else
      state
    end
  end

  defp advance_bullets(%State{} = state) do
    bullets =
      state.bullets
      |> Enum.map(&Entity.advance/1)
      |> Enum.reject(&Entity.outside?(&1, bounds(state)))

    %{state | bullets: bullets}
  end

  defp increment_tick(%State{} = state) do
    %{state | tick: state.tick + 1}
  end

  defp input_move(%{move: %{x: x, y: y}}), do: {normalize(x), normalize(y)}
  defp input_move(%{x: x, y: y}), do: {normalize(x), normalize(y)}
  defp input_move(_), do: {0.0, 0.0}

  defp normalize(value) when value > 0, do: 1.0
  defp normalize(value) when value < 0, do: -1.0
  defp normalize(_value), do: 0.0

  defp bounds(%State{} = state), do: %{width: state.width, height: state.height}
end
