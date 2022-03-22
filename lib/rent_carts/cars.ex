defmodule RentCarts.Cars do
  alias RentCarts.Cars.Car
  alias RentCarts.Repo
  import Ecto.Query
  alias RentCarts.Cars.CarPhoto

  def create_car(payload) do
    %Car{}
    |> Car.changeset(payload)
    |> Repo.insert()
  end

  def create_image(id, images) do
    attrs =
      images
      |> Map.to_list()
      |> Enum.map(fn {_, image} -> %{image: image} end)
      |> then(&%{cars_images: &1})

    id
    |> get_car!()
    |> Repo.preload(:cars_images)
    |> Car.changeset(attrs)
    |> Repo.update()
  end

  def is_car_avilable?(car_id) do
    Car
    |> where([c], c.id == ^car_id)
    |> Repo.one()
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
    |> preload([:specifications, :cars_images])
    |> Repo.all()
  end

  def get_images(car) do
    Enum.map(car.cars_images, &CarPhoto.url({&1.image, &1}))
  end

  def get_car!(id), do: Repo.get!(Car, id)

  def update_car(car_id, payload) do
    car_id
    |> get_car!()
    |> Car.update_changeset(payload)
    |> Repo.update()
  end
end
