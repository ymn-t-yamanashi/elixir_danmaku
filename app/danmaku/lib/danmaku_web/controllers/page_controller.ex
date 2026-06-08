defmodule DanmakuWeb.PageController do
  use DanmakuWeb, :controller

  def home(conn, _params) do
    render(conn, :home, game: Danmaku.Game.snapshot(Danmaku.Game.new()))
  end
end
