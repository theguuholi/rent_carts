defmodule RentCartsWeb.AccountControllerTest do
  use RentCartsWeb.ConnCase

  import RentCarts.AccountsFixtures

  alias RentCarts.Accounts.User

  @create_attrs %{
    drive_license: unique_user_drive_license(),
    email: unique_user_email(),
    name: "some name",
    password: "some password_hash",
    password_confirmation: "some password_hash",
    user_name: unique_user_user_name()
  }
  @update_attrs %{
    drive_license: unique_user_drive_license(),
    email: unique_user_email(),
    name: "some updated name",
    password: "some password_hash",
    password_confirmation: "some password_hash",
    user_name: unique_user_user_name()
  }
  @invalid_attrs %{
    drive_license: nil,
    email: nil,
    name: nil,
    password: nil,
    password_confirmation: nil,
    user_name: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup :include_normal_token_user

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] |> Enum.count() == 1
    end
  end

  describe "create user" do
    setup :include_normal_token_user

    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert id == json_response(conn, 200)["data"]["id"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user, :include_normal_token_user]

    test "renders user when data is valid update", %{conn: conn} do
      photo = %Plug.Upload{
        content_type: "image/png",
        filename: "logo.png",
        path: "test/support/fixtures/logo.png"
      }

      conn = patch(conn, Routes.user_path(conn, :update_foto), photo: photo)

      assert json_response(conn, 201)["data"]["photo_url"] |> String.contains?("logo.png")
    end

    test "renders user when data is valid", %{
      conn: conn,
      user: %User{id: id} = user
    } do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user, :include_normal_token_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
