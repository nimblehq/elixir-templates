defmodule NimbleWeb.PageController do
  use NimbleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
