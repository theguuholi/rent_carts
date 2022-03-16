defmodule RentCarts.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset
  alias RentCarts.Categories.Category

  @fields ~w/available/a
  @required_fields ~w/name description daily_rate available license_plate fine_amount brand category_id/a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cars" do
    field :available, :boolean, default: true
    field :brand, :string
    field :daily_rate, :integer
    field :description, :string
    field :fine_amount, :integer
    field :license_plate, :string
    field :name, :string
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:license_plate)
    |> update_change(:license_plate, &String.upcase/1)
  end
end
