defmodule RentCarts.RentalsTest do
  use RentCarts.DataCase

  alias RentCarts.Rentals
  import RentCarts.CategoriesFixtures
  import RentCarts.AccountsFixtures
  alias RentCarts.Cars

  describe "create rentals" do
    test "create rental" do
      category = category_fixture()

      payload = %{
        name: "Lancer",
        description: "Good car and fast",
        brand: "Mitsubishi",
        daily_rate: 100,
        license_plate: "Abcd_1232",
        fine_amount: 30,
        category_id: category.id,
        available: true
      }

      user = user_fixture()

      expected_return_date =
        NaiveDateTime.utc_now()
        |> then(&%{&1 | day: &1.day + 5})
        |> NaiveDateTime.to_string()

      {:ok, car} = Cars.create_car(payload)
      {:ok, %{insert_rental: rental}} = Rentals.create_rentals(car.id, user.id, expected_return_date)
      assert rental.end_date == nil
      assert rental.car_id == car.id
      assert rental.user_id == user.id
      assert rental.total == nil
    end
  end
end
