defmodule Danmaku.Game.State do
  @moduledoc false

  alias Danmaku.Game.Entity

  defstruct tick: 0,
            width: 320.0,
            height: 640.0,
            player: Entity.player(),
            enemy: Entity.enemy(),
            bullets: []
end
