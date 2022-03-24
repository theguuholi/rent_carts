defmodule RentCarts.Accounts.Core.SendForgotPasswordToEmail do
  use Phoenix.Swoosh, view: RentCartsWeb.EmailView, layout: {RentCartsWeb.EmailView, :layout}
  import Swoosh.Email

  alias RentCarts.Accounts.User
  alias RentCarts.Repo
  alias RentCarts.Shared.Tokenr
  alias RentCarts.Mailer

  def execute(email) do
    User
    |> Repo.get_by!(email: email)
    |> prepare_reponse()
  end

  defp prepare_reponse(nil), do: {:error, :message, "User does not exist"}

  defp prepare_reponse(user) do
    token = Tokenr.generate_forgot_email_token(user)
    Task.async(fn -> send_email(token, user) end)
    {:ok, user, token}
  end

  defp send_email(token, user) do
    url = "/sessions/reset_password?token=#{token}"

    new()
    |> to({user.name, user.email})
    |> from({"Rent cars Elxpro", "adm@elxpro.com"})
    |> subject("[Elxpro] - Reset Password")
    |> render_body("password_forgot.html", %{name: user.name, url: url})
    |> Mailer.deliver()
    |> IO.inspect()
  end
end
