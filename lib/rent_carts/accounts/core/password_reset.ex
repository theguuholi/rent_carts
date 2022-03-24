defmodule RentCarts.Accounts.Core.PasswordReset do
  alias RentCarts.Accounts
  alias RentCarts.Shared.Tokenr

  def execute(params) do
    params
    |> Map.get("token")
    |> Tokenr.verify_forgot_email_token()
    |> perform(params)
  end

  defp perform({:ok, user}, params) do
    Accounts.update_user(user, params)
  end

  defp perform({:error, :expired}, _params) do
    {:error, :message, "Invalid token"}
  end
end
