defmodule RentCarts.Cars.CarImage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cars_images" do
    field :image, :string
    field :car_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(car_image, attrs) do
    car_image
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end
end
