defmodule DanmakuWeb.PageController do
  use DanmakuWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
