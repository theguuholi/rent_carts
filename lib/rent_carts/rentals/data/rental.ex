defmodule RentCarts.Rentals.Data.Rental do
  use Ecto.Schema
  import Ecto.Changeset
  alias RentCarts.Cars.Car
  alias RentCarts.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rentals" do
    field :end_date, :naive_datetime
    field :expected_return_date, :naive_datetime
    field :start_date, :naive_datetime
    field :total, :integer
    belongs_to :car, Car
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(rental, attrs) do
    rental
    |> cast(attrs, [:start_date, :end_date, :expected_return_date, :total, :user_id, :car_id])
    |> validate_required([:start_date, :expected_return_date, :user_id, :car_id])
  end
end
