defmodule DanmakuWeb.HomeLive do
  use DanmakuWeb, :live_view

  alias Danmaku.Game

  @tick_interval_ms 200

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
end
