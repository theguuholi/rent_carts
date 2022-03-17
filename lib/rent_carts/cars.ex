defmodule RentCarts.Cars do
  alias RentCarts.Cars.Car
  alias RentCarts.Repo
  import Ecto.Query

  def create_car(payload) do
    %Car{}
    |> Car.changeset(payload)
    |> Repo.insert()
  end

  def list_cars(filters \\ []) when is_list(filters) do
    query = where(Car, [c], c.available == true)

    Enum.reduce(filters, query, fn
      {:category, category}, query ->
        category = "%" <> category <> "%"

        query
        |> join(:inner, [c], ca in assoc(c, :category))
        |> where([c, ca], ilike(ca.name, ^category))

      {:name, name}, query ->
        name = "%" <> name <> "%"
        where(query, [c], ilike(c.name, ^name))

      {:brand, brand}, query ->
        brand = "%" <> brand <> "%"
        where(query, [c], ilike(c.brand, ^brand))
    end)
    |> preload(:specifications)
    |> Repo.all()
  end
end
