defmodule RentCartsWeb.SpecificationControllerTest do
  use RentCartsWeb.ConnCase

  import RentCarts.SpecificationsFixtures

  alias RentCarts.Specifications.Specification

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: ""}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup :include_bearer_admin_token

    test "lists all specifications", %{conn: conn} do
      conn = get(conn, Routes.specification_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create specification" do
    setup :include_bearer_admin_token

    test "renders specification when data is valid", %{conn: conn} do
      conn = post(conn, Routes.specification_path(conn, :create), specification: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.specification_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "SOME NAME"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.specification_path(conn, :create), specification: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update specification" do
    setup [:create_specification, :include_bearer_admin_token]

    test "renders specification when data is valid", %{
      conn: conn,
      specification: %Specification{id: id} = specification
    } do
      conn =
        put(conn, Routes.specification_path(conn, :update, specification),
          specification: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.specification_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "SOME UPDATED NAME"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, specification: specification} do
      conn =
        put(conn, Routes.specification_path(conn, :update, specification),
          specification: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete specification" do
    setup [:create_specification, :include_bearer_admin_token]

    test "deletes chosen specification", %{conn: conn, specification: specification} do
      conn = delete(conn, Routes.specification_path(conn, :delete, specification))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.specification_path(conn, :show, specification))
      end
    end
  end

  defp create_specification(_) do
    specification = specification_fixture()
    %{specification: specification}
  end
end
