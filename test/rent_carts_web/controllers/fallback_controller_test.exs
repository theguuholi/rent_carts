defmodule RentCartsWeb.FallbackControllerTest do
  use RentCartsWeb.ConnCase

  describe "index" do
    setup :include_admin_token

    test "fallback error message", %{conn: conn} do
      conn =
        post(conn, Routes.session_path(conn, :create, email: "13213@2323", password: "12313"))

      assert json_response(conn, 422)["error"] == "Email or password is incorrect!"
    end

    test "fallback error invalid message and plug", %{conn: conn} do
      conn =
        Plug.Conn.put_req_header(
          conn,
          "authorization",
          "Bearer " <> "sfsldjkljksdfkljsdfjklljksdfkjlsdfkljfds"
        )

      conn = post(conn, Routes.session_path(conn, :me), token: "fsdfdssdfdsfsd")

      assert json_response(conn, 401)["error"] == "unauthenticated"
    end
  end
end
