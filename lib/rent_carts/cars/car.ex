defmodule RentCarts.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset
  alias RentCarts.Categories.Category
  alias RentCarts.Specifications.Specification

  @fields ~w/available/a
  @required_fields ~w/name description daily_rate available license_plate fine_amount brand category_id/a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cars" do
    field :available, :boolean, default: true
    field :brand, :string
    field :daily_rate, :integer
    field :description, :string
    field :fine_amount, Money.Ecto.Amount.Type
    field :license_plate, :string
    field :name, :string
    belongs_to :category, Category
    many_to_many :specifications, Specification, join_through: RentCarts.Cars.SpecificationCar
    has_many :cars_images, RentCarts.Cars.CarImage
    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:specifications, with: &Specification.changeset/2)
    |> cast_assoc(:cars_images, with: &RentCarts.Cars.CarImage.changeset/2)
    |> unique_constraint(:license_plate)
    |> update_change(:license_plate, &String.upcase/1)
  end

  def update_changeset(car, attrs) do
    car
    |> changeset(attrs)
    |> validate_change(:license_plate, fn :license_plate, license_plate ->
      if car.license_plate != license_plate do
        [license_plate: "you can`t update license_plate"]
      else
        []
      end
    end)
  end
end
