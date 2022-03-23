defmodule RentCarts.Rentals do
  alias RentCarts.Rentals.Core.CreateRental
  alias RentCarts.Repo
  alias RentCarts.Rentals.Data.Rental
  import Ecto.Query

  def get(id), do: Rental |> Repo.get(id)

  def get(id, user_id) do
    Rental
    |> where([r], r.id == ^id)
    |> where([r], r.user_id == ^user_id)
    |> Repo.one()
  end

  defdelegate create_rentals(car_id, user_id, expected_return_date),
    to: CreateRental,
    as: :execute
end
