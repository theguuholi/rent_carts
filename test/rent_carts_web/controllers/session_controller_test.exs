defmodule RentCartsWeb.SessionControllerTest do
  use RentCartsWeb.ConnCase

  describe "index" do
    setup :include_normal_token_user

    test "create token", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.session_path(conn, :create, email: user.email, password: user.password))

      assert json_response(conn, 201)["data"]["user"]["data"]["email"] == user.email
    end

    test "get me", %{conn: conn, user: user, token: token} do
      conn = post(conn, Routes.session_path(conn, :me, token: token))

      assert json_response(conn, 201)["data"]["user"]["data"]["email"] == user.email
    end
  end
end
