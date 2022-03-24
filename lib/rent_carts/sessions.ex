defmodule RentCarts.Sessions do
  import Ecto.Query, warn: false
  alias RentCarts.Accounts.User
  alias RentCarts.Repo
  alias RentCarts.Shared.Tokenr
  alias RentCarts.Accounts.Core.SendForgotPasswordToEmail

  @error_return {:error, :message, "Email or password is incorrect!"}

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
      token = Tokenr.generate_auth_token(user)
      {:ok, user, token}
    else
      @error_return
    end
  end

  def me(token), do: Tokenr.verify_auth_token(token)

  defdelegate forgot_password(email), to: SendForgotPasswordToEmail, as: :execute
end
