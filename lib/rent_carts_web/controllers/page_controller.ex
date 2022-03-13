defmodule RentCartsWeb.PageController do
  use RentCartsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
