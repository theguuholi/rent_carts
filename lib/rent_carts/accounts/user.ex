defmodule RentCarts.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @role_values ~w(USER ADMIN)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :drive_license, :string
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :user_name, :string
    field :role, Ecto.Enum, values: @role_values, default: :USER
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :user_name, :password_hash, :email, :drive_license])
    |> validate_required([:name, :user_name, :password_hash, :email, :drive_license])
    |> unique_constraint(:drive_license)
    |> unique_constraint(:email)
    |> unique_constraint(:user_name)
  end
end
