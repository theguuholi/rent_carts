defmodule RentCarts.Sessions do
  import Ecto.Query, warn: false
  alias Phoenix.Token
  alias RentCarts.Accounts.User
  alias RentCarts.Repo
  alias RentCartsWeb.Endpoint

  @error_return {:error, :message, "Email or password is incorrect!"}
  @login_token "login_user_token"

  def create(email, password) do
    User
    |> Repo.get_by(email: email)
    |> check_user_exist()
    |> validate_password(password)
  end

  defp check_user_exist(nil), do: @error_return
  defp check_user_exist(user), do: user

  defp validate_password({:error, _, _} = err, _password), do: err

  defp validate_password(user, password) do
    if Argon2.verify_pass(password, user.password_hash) do
      token = Token.sign(Endpoint, @login_token, user)
      {:ok, user, token}
    else
      @error_return
    end
  end

  def me(token) do
    Token.verify(Endpoint, @login_token, token, max_age: 86_400)
  end
end
