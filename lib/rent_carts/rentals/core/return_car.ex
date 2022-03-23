defmodule RentCarts.Rentals.Core.ReturnCar do
  alias RentCarts.Rentals
  alias RentCarts.Rentals.Data.Rental
  alias RentCarts.Cars.Car
  alias RentCarts.Cars
  alias RentCarts.Repo

  def execute(id, user_id) do
    with %Rental{} = rental <- validate_rental(id, user_id),
         {daily, delay} <- compare_date(rental),
         {total, car} <- calculate_fees(rental, {daily, delay}) do
      update_rental(rental, car, total)
    else
      error -> error
    end
  end

  defp validate_rental(id, user_id) do
    rental = Rentals.get(id, user_id)

    if rental == nil do
      {:error, "Rental does not exists!"}
    else
      rental
    end
  end

  def compare_date(%{expected_return_date: expected_return_date} = rental) do
    date_now = NaiveDateTime.utc_now()
    daily = Timex.diff(date_now, rental.start_date, :days)
    daily = (daily <= 0 && 1) || daily
    delay = Timex.diff(date_now, expected_return_date, :days)
    {daily, delay}
  end

  def calculate_fees(rental, {daily, delay}) do
    car = Cars.get_car!(rental.car_id)
    calculate_fine = (delay > 0 && delay * car.fine_amount.amount) || 0
    total = daily * car.daily_rate + calculate_fine
    {total, car}
  end

  defp update_rental(rental, car, total) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:car_is_available, Car.changeset(car, %{available: true}))
    |> Ecto.Multi.update(
      :finish_rental,
      Rental.changeset(rental, %{total: total, end_date: NaiveDateTime.utc_now()})
    )
    |> Repo.transaction()
  end
end
