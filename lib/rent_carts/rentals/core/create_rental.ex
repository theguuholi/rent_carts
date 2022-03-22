defmodule RentCarts.Rentals.Core.CreateRental do
  alias RentCarts.Cars
  alias RentCarts.Repo
  alias RentCarts.Rentals.Data.Rental
  alias RentCarts.Accounts.User
  alias RentCarts.Shared.DateValidations
  import Ecto.Query

  def execute(car_id, user_id, expected_return_date) do
    with :ok <- DateValidations.is_more_than_24_hours?(expected_return_date),
         :ok <- is_car_avilable?(car_id),
         :ok <- is_user_booked_car?(user_id) do
      store_rental({car_id, user_id}, expected_return_date)
    else
      error -> error
    end
  end

  def is_car_avilable?(car_id) do
    car_id
    |> Cars.is_car_avilable?()
    |> return_car_available()
  end

  defp return_car_available({true, _car_id}), do: :ok
  defp return_car_available({false, _}), do: {:error, :message, "Car is unavailable"}

  defp is_user_booked_car?(user_id) do
    User
    |> join(:inner, [u], r in assoc(u, :rentals))
    |> where([u, r], u.id == ^user_id)
    |> where([u, r], is_nil(r.end_date))
    |> select([u, r], count(u.id))
    |> Repo.one()
    |> then(fn result ->
      if result == 0 do
        :ok
      else
        {:error, :message, "User has a reservation"}
      end
    end)
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
