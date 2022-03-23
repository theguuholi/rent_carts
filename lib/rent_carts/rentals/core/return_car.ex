defmodule RentCarts.Rentals.Core.ReturnCar do
  alias RentCarts.Rentals
  alias RentCarts.Rentals.Data.Rental
  alias RentCarts.Cars
  alias RentCarts.Repo

  def execute(id, user_id) do
    with %Rental{} = rental <- validate_rental(id), :ok <- compare_date(rental) do
      :ok
    else
      error -> error
    end
  end

  defp validate_rental(id) do
    rental = Rentals.get(id)

    if rental == nil do
      {:error, "Rental does not exists!"}
    else
      rental
    end
  end

  defp compare_date(%{expected_return_date: expected_return_date} = rental) do
    date_now = NaiveDateTime.utc_now()

    daily = Timex.diff(rental.start_date, date_now, :days)
    minimum_daily = 1

    daily = (daily <= 0 && minimum_daily) || daily

    delay = Timex.diff(expected_return_date, date_now, :days)

    car = Cars.get_car!(rental.car_id)

    calculate_fine = (delay > 0 && delay * car.fine_amount.amount) || 0

    total = daily * car.daily_rate + calculate_fine

    Cars.update_car(car.id, %{available: true})

    rental
    |> Rental.changeset(%{total: total, end_date: date_now})
    |> Repo.update()
  end
end
