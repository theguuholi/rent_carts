defmodule RentCartsWeb.CategoryControllerTest do
  use RentCartsWeb.ConnCase

  import RentCarts.CategoriesFixtures

  alias RentCarts.Categories.Category

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup :include_bearer_admin_token

    test "lists all categories", %{conn: conn} do
      conn = get(conn, Routes.category_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create category" do
    setup :include_bearer_admin_token

    test "renders category when data is valid", %{conn: conn} do
      conn = post(conn, Routes.category_path(conn, :create), category: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.category_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "SOME NAME"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.category_path(conn, :create), category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update category" do
    setup [:create_category, :include_bearer_admin_token]

    test "renders category when data is valid", %{
      conn: conn,
      category: %Category{id: id} = category
    } do
      conn = put(conn, Routes.category_path(conn, :update, category), category: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.category_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "SOME UPDATED NAME"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put(conn, Routes.category_path(conn, :update, category), category: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete category" do
    setup [:create_category, :include_bearer_admin_token]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, Routes.category_path(conn, :delete, category))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.category_path(conn, :show, category))
      end
    end
  end

  defp create_category(_) do
    category = category_fixture()
    %{category: category}
  end
end
