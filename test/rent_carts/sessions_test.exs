defmodule RentCarts.SessionsTest do
  use RentCarts.DataCase

  alias RentCarts.Sessions
  import RentCarts.AccountsFixtures

  describe "sessions" do
    test "return authenticated user" do
      user = user_fixture()
      {:ok, user_return, _token} = Sessions.create(user.email, "some password_hash")
      assert user_return.email == user.email
    end

    test "return error when password is not correct" do
      user = user_fixture()
      result = Sessions.create(user.email, "somedsfsfdsfsdf")
      assert result == {:error, :message, "Email or password is incorrect!"}
    end

    test "return error when user does not exist" do
      result = Sessions.create("fdsf@fdsfs", "sdfdsf")
      assert result == {:error, :message, "Email or password is incorrect!"}
    end

    test "return me" do
      user = user_fixture()
      {:ok, _user_return, token} = Sessions.create(user.email, "some password_hash")
      {:ok, user_return} = Sessions.me(token)
      assert user_return.email == user.email
    end
  end
end
