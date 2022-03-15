defmodule RentCarts.Shared.Tokenr do
  alias Phoenix.Token
  alias RentCartsWeb.Endpoint

  @login_token "login_user_token"
  @max_age 86_400

  def generate_auth_token(user), do: Token.sign(Endpoint, @login_token, user)

  def verify_auth_token(token), do: Token.verify(Endpoint, @login_token, token, max_age: @max_age)
end
