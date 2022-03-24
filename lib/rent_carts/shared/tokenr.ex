defmodule RentCarts.Shared.Tokenr do
  alias Phoenix.Token
  alias RentCartsWeb.Endpoint

  @login_token "login_user_token"
  @reset_password "reset_password"
  @max_age 86_400
  @max_age_reset_token_age 604_800

  def generate_auth_token(user), do: Token.sign(Endpoint, @login_token, user)

  def verify_auth_token(token), do: Token.verify(Endpoint, @login_token, token, max_age: @max_age)

  def generate_forgot_email_token(user) do
    Phoenix.Token.sign(Endpoint, @reset_password, user)
  end

  def verify_forgot_email_token(token) do
    Phoenix.Token.verify(Endpoint, @reset_password, token, max_age: @max_age_reset_token_age)
  end
end
