defmodule RentCartsWeb.SessionController do
  use RentCartsWeb, :controller

  alias RentCarts.Accounts.User
  alias RentCarts.Sessions

  action_fallback RentCartsWeb.FallbackController

  def create(conn, %{"password" => password, "email" => email}) do
    with {:ok, %User{} = user} <- Sessions.create(email, password) do
      session = %{user: user}

      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    end
  end
end
