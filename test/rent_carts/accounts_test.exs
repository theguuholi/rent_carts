defmodule RentCarts.AccountsTest do
  use RentCarts.DataCase

  alias RentCarts.Accounts

  describe "users" do
    alias RentCarts.Accounts.User

    import RentCarts.AccountsFixtures

    @invalid_attrs %{
      drive_license: nil,
      email: nil,
      name: nil,
      password_hash: nil,
      user_name: nil
    }

    test "list_users/0 returns all users" do
      user_fixture()
      assert Accounts.list_users() |> Enum.count() == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        drive_license: "some drive_license",
        email: "some@email",
        name: "some name",
        password: "some password_hash",
        password_confirmation: "some password_hash",
        user_name: "some user_name"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.drive_license == "some drive_license"
      assert user.email == "some@email"
      assert user.name == "some name"
      assert user.user_name == "SOME USER_NAME"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        drive_license: "some updated drive_license",
        email: "some@updatedemail",
        name: "some updated name",
        password_hash: "some updated password_hash",
        user_name: "some updated user_name"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.drive_license == "some updated drive_license"
      assert user.email == "some@updatedemail"
      assert user.name == "some updated name"
      assert user.user_name == "SOME UPDATED USER_NAME"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.email == Accounts.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
