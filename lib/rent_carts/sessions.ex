defmodule RentCarts.Sessions do
  import Ecto.Query, warn: false
  alias RentCarts.Repo

  alias RentCarts.Accounts.User

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
      {:ok, user}
    else
      @error_return
    end
  end
end
