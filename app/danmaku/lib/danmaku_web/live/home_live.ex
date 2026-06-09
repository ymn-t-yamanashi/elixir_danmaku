defmodule DanmakuWeb.HomeLive do
  use DanmakuWeb, :live_view

  alias Danmaku.Game

  @tick_interval_ms 200
  @movement_keys %{
    "ArrowUp" => %{move: %{x: 0.0, y: -1.0}},
    "ArrowDown" => %{move: %{x: 0.0, y: 1.0}},
    "ArrowLeft" => %{move: %{x: -1.0, y: 0.0}},
    "ArrowRight" => %{move: %{x: 1.0, y: 0.0}},
    "w" => %{move: %{x: 0.0, y: -1.0}},
    "s" => %{move: %{x: 0.0, y: 1.0}},
    "a" => %{move: %{x: -1.0, y: 0.0}},
    "d" => %{move: %{x: 1.0, y: 0.0}},
    "W" => %{move: %{x: 0.0, y: -1.0}},
    "S" => %{move: %{x: 0.0, y: 1.0}},
    "A" => %{move: %{x: -1.0, y: 0.0}},
    "D" => %{move: %{x: 1.0, y: 0.0}}
  }

  @doc "初期状態を受け取って LiveView を立ち上げる。"
  @impl true
  def mount(_params, _session, socket) do
    state = Game.new()

    socket =
      socket
      |> assign(:state, state)
      |> assign(:game, Game.snapshot(state))
      |> assign(:tick_interval_ms, @tick_interval_ms)

    if connected?(socket) do
      schedule_tick(socket)
    end

    {:ok, socket}
  end

  @doc "キー入力を自機移動へ変換する。"
  @impl true
  def handle_event("move", %{"key" => key}, socket) do
    input = key_to_input(key)

    if input == %{move: %{x: 0.0, y: 0.0}} do
      {:noreply, socket}
    else
      state = Game.move(socket.assigns.state, input)

      socket =
        socket
        |> assign(:state, state)
        |> assign(:game, Game.snapshot(state))

      {:noreply, socket}
    end
  end

  @doc "定期タイマーで 1 フレーム分の更新を進める。"
  @impl true
  def handle_info(:tick, socket) do
    state = Game.step(socket.assigns.state, %{})

    socket =
      socket
      |> assign(:state, state)
      |> assign(:game, Game.snapshot(state))

    schedule_tick(socket)
    {:noreply, socket}
  end

  defp schedule_tick(socket) do
    Process.send_after(self(), :tick, socket.assigns.tick_interval_ms)
    socket
  end

  defp key_to_input(key) do
    Map.get(@movement_keys, key, %{move: %{x: 0.0, y: 0.0}})
  end
end
