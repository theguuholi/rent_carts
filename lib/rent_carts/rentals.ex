defmodule RentCarts.Rentals do
  alias RentCarts.Rentals.Core.CreateRental
  alias RentCarts.Repo
  alias RentCarts.Rentals.Core.ReturnCar
  alias RentCarts.Rentals.Data.Rental
  import Ecto.Query

  def get(id), do: Rental |> Repo.get(id)

  def list_rentals(user_id) do
    Rental
    |> where([r], r.user_id == ^user_id)
    |> preload(:car)
    |> Repo.all()
  end

  def get(id, user_id) do
    Rental
    |> where([r], r.id == ^id)
    |> where([r], r.user_id == ^user_id)
    |> Repo.one()
  end

  defdelegate return_car(rental_id, user_id), to: ReturnCar, as: :execute

  defdelegate create_rentals(car_id, user_id, expected_return_date),
    to: CreateRental,
    as: :execute
end
