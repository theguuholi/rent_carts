defmodule RentCartsWeb.Middlewares.IsAdmin do
  import Plug.Conn
  alias RentCarts.Shared.Tokenr

  def init(o), do: o

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Tokenr.verify_auth_token(token),
         true <- user.role == :ADMIN do
      put_req_header(conn, "user_id", user.id)
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "User does not have this permission/Invalid Token"}))
        |> halt()
    end
  end
end
