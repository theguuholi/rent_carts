defmodule RentCarts.Cars.SpecificationCar do
  use Ecto.Schema
  import Ecto.Changeset
  alias RentCarts.Specifications.Specification
  alias RentCarts.Cars.Car

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "specifications_cars" do

    belongs_to :car, Car
    belongs_to :specification, Specification

    timestamps()
  end

  @doc false
  def changeset(specification_car, attrs) do
    specification_car
    |> cast(attrs, [])
    |> validate_required([])
  end
end
