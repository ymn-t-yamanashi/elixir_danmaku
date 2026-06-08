defmodule Danmaku.Game.Entity do
  @moduledoc false

  defstruct [:id, :kind, :x, :y, :vx, :vy, :speed, :radius]

  def player do
    %__MODULE__{
      id: :player,
      kind: :player,
      x: 160.0,
      y: 540.0,
      vx: 0.0,
      vy: 0.0,
      speed: 6.0,
      radius: 8.0
    }
  end

  def enemy do
    %__MODULE__{
      id: :enemy_1,
      kind: :enemy,
      x: 160.0,
      y: 120.0,
      vx: 0.0,
      vy: 0.0,
      speed: 0.0,
      radius: 14.0
    }
  end

  def bullet(id, x, y, vy) do
    %__MODULE__{
      id: id,
      kind: :bullet,
      x: x,
      y: y,
      vx: 0.0,
      vy: vy,
      speed: abs(vy),
      radius: 4.0
    }
  end

  def move(%__MODULE__{} = entity, dx, dy, %{width: width, height: height}) do
    next_x =
      entity.x +
        clamp(dx, -1.0, 1.0) * entity.speed

    next_y =
      entity.y +
        clamp(dy, -1.0, 1.0) * entity.speed

    %{
      entity
      | x: clamp(next_x, entity.radius, width - entity.radius),
        y: clamp(next_y, entity.radius, height - entity.radius)
    }
  end

  def advance(%__MODULE__{} = entity) do
    %{entity | x: entity.x + (entity.vx || 0.0), y: entity.y + (entity.vy || 0.0)}
  end

  def outside?(%__MODULE__{} = entity, %{width: width, height: height}) do
    entity.x < -entity.radius or
      entity.x > width + entity.radius or
      entity.y < -entity.radius or
      entity.y > height + entity.radius
  end

  defp clamp(value, min, _max) when value < min, do: min
  defp clamp(value, _min, max) when value > max, do: max
  defp clamp(value, _min, _max), do: value
end
