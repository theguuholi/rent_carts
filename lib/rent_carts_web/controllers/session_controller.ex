defmodule RentCartsWeb.SessionController do
  use RentCartsWeb, :controller

  alias RentCarts.Accounts.User
  alias RentCarts.Sessions

  action_fallback RentCartsWeb.FallbackController

  def me(conn, %{"token" => token}) do
    with {:ok, user} <- Sessions.me(token) do
      session = %{user: user, token: token}

      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    end
  end

  def create(conn, %{"password" => password, "email" => email}) do
    with {:ok, %User{} = user, token} <- Sessions.create(email, password) do
      session = %{user: user, token: token}

      conn
      |> put_status(:created)
      |> render("show.json", session: session)
    end
  end

  def reset_password(conn, %{"email" => email}) do
    with {:ok, _user, _token} <- Sessions.forgot_password(email) do
      conn
      |> put_status(:no_content)
      |> put_resp_header("content-type", "application/json")
      |> text("")
    end
  end
end
