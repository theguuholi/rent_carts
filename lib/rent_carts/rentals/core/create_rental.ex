defmodule RentCarts.Rentals.Core.CreateRental do
  alias RentCarts.Cars
  alias RentCarts.Repo
  alias RentCarts.Rentals.Data.Rental
  alias RentCarts.Shared.DateValidations

  def execute(car_id, user_id, expected_return_date) do
    with :ok <- DateValidations.is_more_than_24_hours?(expected_return_date),
         :ok <- is_car_avilable?(car_id) do
      store_rental({car_id, user_id}, expected_return_date)
    else
      error -> error
    end

    # # check with rental == nil
    # |> check_is_user_has_a_rental(user_id)
  end

  def is_car_avilable?(car_id) do
    car_id
    |> Cars.is_car_avilable?()
    |> return_car_available()
  end

  defp return_car_available({true, _car_id}), do: :ok
  defp return_car_available({false, _}), do: {:error, :message, "Car is unavailable"}

  defp check_is_user_has_a_rental({:error, _, _} = err, _user_id), do: err

  defp check_is_user_has_a_rental(car_id, user_id) do
    # if rental has user_id and end_date == nil show the error
    # {:error, :message, "User has a a car reservade"}
    {car_id, user_id}
  end

  defp store_rental({car_id, user_id}, expected_return_date) do
    payload = %{
      car_id: car_id,
      user_id: user_id,
      start_date: NaiveDateTime.utc_now(),
      expected_return_date: expected_return_date
    }

    %Rental{}
    |> Rental.changeset(payload)
    |> Repo.insert()
  end
end
