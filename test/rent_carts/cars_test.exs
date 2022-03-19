defmodule RentCarts.CarsTest do
  use RentCarts.DataCase

  alias RentCarts.Cars
  import RentCarts.CategoriesFixtures

  describe "create cars" do
    test "should not be possible to update license_plate for a car that already exist" do
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

      {:ok, car} = Cars.create_car(payload)
      assert payload.name == car.name

      payload = %{
        name: "Lancer",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "dddddd",
        fine_amount: 30,
        category_id: category.id
      }

      {:error, changeset} = Cars.update_car(car.id, payload)
      assert "you can`t update license_plate" in errors_on(changeset).license_plate
    end

    test "should be able to create a car" do
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

      {:ok, result} = Cars.create_car(payload)
      assert payload.name == result.name
    end

    test "list all available cars" do
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

      Cars.create_car(payload)

      payload = %{
        name: "Lancer",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "Abcd_1232",
        fine_amount: 30,
        category_id: category.id,
        available: false
      }

      Cars.create_car(payload)

      assert Cars.list_cars() |> Enum.count() == 1
    end

    test "list all available cars by name" do
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

      Cars.create_car(payload)

      payload = %{
        name: "Lancer",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "Abcd_1232",
        fine_amount: 30,
        category_id: category.id,
        available: false
      }

      Cars.create_car(payload)

      assert Cars.list_cars(name: "Lan") |> Enum.count() == 1
      assert Cars.list_cars(brand: "Mit") |> Enum.count() == 1
      assert Cars.list_cars(category: category.name) |> Enum.count() == 1
      assert Cars.list_cars(category: category.name, brand: "Mit") |> Enum.count() == 1
    end

    test "should not be able to create a car tha place already exist" do
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

      {:ok, _result} = Cars.create_car(payload)
      result = Cars.create_car(payload)
      assert {:error, changeset} = result
      assert "has already been taken" in errors_on(changeset).license_plate
      assert %{license_plate: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
