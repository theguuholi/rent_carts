defmodule RentCarts.Rentals.Core.ReturnCarTest do
  use RentCarts.DataCase

  import RentCarts.CategoriesFixtures
  import RentCarts.AccountsFixtures
  alias RentCarts.Rentals.Core.CreateRental
  alias RentCarts.Rentals.Core.ReturnCar
  alias RentCarts.Cars

  describe "create rentals" do
    test "error when rental does not exist" do
      user = user_fixture()

      assert {:error, "Rental does not exists!"} ==
               ReturnCar.execute(Ecto.UUID.generate(), user.id)
    end

    test "should if there is a delay" do
      expected_return_date =
        NaiveDateTime.utc_now()
        |> then(&%{&1 | day: &1.day - 5})

      start_date =
        NaiveDateTime.utc_now()
        |> then(&%{&1 | day: &1.day - 7})

      rental = %{
        expected_return_date: expected_return_date,
        start_date: start_date
      }

      assert {7, 5} == ReturnCar.compare_date(rental)
    end

    test "intead of 0 return day 1" do
      expected_return_date =
        NaiveDateTime.utc_now()
        |> then(&%{&1 | day: &1.day + 5})

      start_date = NaiveDateTime.utc_now()

      rental = %{
        expected_return_date: expected_return_date,
        start_date: start_date
      }

      assert {1, -4} == ReturnCar.compare_date(rental)
    end

    test "return total fees" do
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

      {:ok, car} = Cars.create_car(payload)
      {total, _car} = ReturnCar.calculate_fees(%{car_id: car.id}, {1, -4})
      assert total == 100
    end

    test "return total fees for 3 days" do
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

      {:ok, car} = Cars.create_car(payload)
      {total, _car} = ReturnCar.calculate_fees(%{car_id: car.id}, {3, 0})
      assert total == 300
    end

    test "return total fees forwith fine amount" do
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

      {:ok, car} = Cars.create_car(payload)
      {total, _car} = ReturnCar.calculate_fees(%{car_id: car.id}, {3, 3})
      assert total == 390
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

      {:ok,
       %{
         car_is_available: %{available: available_result},
         finish_rental: %{end_date: end_date, total: total}
       }} = ReturnCar.execute(rental.id, user.id)

      assert available_result == true
      assert !is_nil(end_date)
      assert total == 100
    end
  end
end
