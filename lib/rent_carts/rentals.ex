defmodule RentCarts.Rentals do
  alias RentCarts.Rentals.Core.CreateRental
  alias RentCarts.Repo
  alias RentCarts.Rentals.Data.Rental

  def get(id), do: Rental |> Repo.get(id)

  defdelegate create_rentals(car_id, user_id, expected_return_date),
    to: CreateRental,
    as: :execute
end
