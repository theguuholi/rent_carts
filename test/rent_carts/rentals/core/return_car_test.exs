defmodule RentCarts.Rentals.Core.ReturnCarTest do
  use RentCarts.DataCase

  import RentCarts.CategoriesFixtures
  import RentCarts.AccountsFixtures
  alias RentCarts.Rentals.Core.CreateRental
  alias RentCarts.Rentals.Core.ReturnCar
  alias RentCarts.Cars

  describe "create rentals" do
    test "error when rental does not exist" do
      assert {:error, "Rental does not exists!"} == ReturnCar.execute(Ecto.UUID.generate, "sdfdsfsdfdfs")
    end

    test "return rental" do
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

      {:ok, %{insert_rental: rental}} =
        CreateRental.execute(car.id, user.id, expected_return_date)

      assert :ok == ReturnCar.execute(rental.id, user.id)
    end
  end
end
