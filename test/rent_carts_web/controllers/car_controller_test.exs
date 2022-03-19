defmodule RentCartsWeb.CarControllerTest do
  use RentCartsWeb.ConnCase
  import RentCarts.CategoriesFixtures
  alias RentCarts.Cars

  describe "test car" do
    setup :include_admin_token

    test "test car creation", %{conn: conn} do
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

    test "test update car", %{conn: conn} do
      category = category_fixture()

      payload = %{
        name: "ddddd",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "Abcd_1232",
        fine_amount: 30,
        category_id: category.id
      }

      {:ok, car} = Cars.create_car(payload)

      conn = put(conn, Routes.car_path(conn, :update, car), car: payload)
      assert json_response(conn, 200)["data"]["name"] == "ddddd"
    end

    test "test list car", %{conn: conn} do
      category = category_fixture()

      payload = %{
        name: "Lancer",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "Abcd_1232",
        fine_amount: 30,
        category_id: category.id,
        specifications: [
          %{name: "dasfds", description: "sdfdsfjlksdfklj"}
        ]
      }

      Cars.create_car(payload)
      conn = get(conn, Routes.car_path(conn, :index))
      response = json_response(conn, 200)["data"]
      assert response |> hd |> then(& &1["brand"]) == "Mitsubishi"
    end
  end
end
