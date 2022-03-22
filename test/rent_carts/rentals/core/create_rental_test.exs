defmodule RentCarts.Rentals.Core.CreateRentalTest do
  use RentCarts.DataCase

  import RentCarts.CategoriesFixtures
  import RentCarts.AccountsFixtures
  alias RentCarts.Rentals.Core.CreateRental
  alias RentCarts.Cars

  describe "create rentals" do
    test "should throw error when car is not available" do
      category = category_fixture()

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

      user = user_fixture()

      expected_return_date =
        NaiveDateTime.utc_now() |> then(&%{&1 | day: &1.day + 5}) |> NaiveDateTime.to_string()

      {:ok, car} = Cars.create_car(payload)
      {:error, :message, message} = CreateRental.execute(car.id, user.id, expected_return_date)
      assert message == "Car is unavailable"
    end

    test "should throw error when user is has a book car" do
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
      CreateRental.execute(car.id, user.id, expected_return_date)
      {:error, :message, message} = CreateRental.execute(car.id, user.id, expected_return_date)
      assert message == "User has a reservation"
    end

    test "should validate if it is before 24 hours" do
      expected_return_date =
        NaiveDateTime.utc_now() |> then(&%{&1 | hour: &1.hour + 5}) |> NaiveDateTime.to_string()

      {:error, :message, rental} = CreateRental.execute("fsdfsd", "Dfdsf", expected_return_date)
      assert rental == "Invalid return date"
    end

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
      {:ok, rental} = CreateRental.execute(car.id, user.id, expected_return_date)
      assert rental.end_date == nil
      assert rental.car_id == car.id
      assert rental.user_id == user.id
      assert rental.total == nil
    end
  end
end
