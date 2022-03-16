defmodule RentCarts.Car do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w/name description daily_rate available license_plate fine_amount brand/a
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
    field :category_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
