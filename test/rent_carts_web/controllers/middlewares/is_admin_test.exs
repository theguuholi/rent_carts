defmodule RentCartsWeb.Middlewares.IsAdminTest do
  use RentCartsWeb.ConnCase
  import RentCarts.CategoriesFixtures

  test "try to login and get error message", %{conn: conn} do
    conn = post(conn, Routes.car_path(conn, :create, car: %{}))
    assert json_response(conn, 401)["error"] == "User does not have this permission"
  end

  describe "test middleware" do
    setup :include_admin_token

    test "test success middleware", %{conn: conn} do
      category = category_fixture()

      payload = %{
        name: "Lancer",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "Abcd_1232",
        fine_amount: 30,
        category_id: category.id
      }

      conn = post(conn, Routes.car_path(conn, :create, car: payload))
      assert json_response(conn, 201)["data"]["brand"] == "Mitsubishi"
    end
  end
end
