defmodule RentCarts.Cars do
  alias RentCarts.Cars.Car
  alias RentCarts.Repo

  def create_car(payload) do
    %Car{}
    |> Car.changeset(payload)
    |> Repo.insert()
  end
end
