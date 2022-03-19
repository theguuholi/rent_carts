defmodule RentCarts.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RentCarts.Accounts` context.
  """

  @doc """
  Generate a unique user drive_license.
  """
  def unique_user_drive_license, do: "some drive_license#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some@email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user user_name.
  """
  def unique_user_user_name, do: "some user_name#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        drive_license: unique_user_drive_license(),
        email: unique_user_email(),
        name: "some name",
        password: "some password_hash",
        password_confirmation: "some password_hash",
        user_name: unique_user_user_name()
      })
      |> RentCarts.Accounts.create_user()

    user
  end

  def user_admin_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        drive_license: unique_user_drive_license(),
        email: unique_user_email(),
        name: "some name",
        password: "some password_hash",
        password_confirmation: "some password_hash",
        user_name: unique_user_user_name(),
        role: "ADMIN"
      })
      |> RentCarts.Accounts.create_user()

    user
  end
end
