defmodule RentCarts.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w/role/a
  @required_fields ~w/name user_name password password_confirmation email drive_license/a
  @role_values ~w(USER ADMIN)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :drive_license, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :user_name, :string
    field :role, Ecto.Enum, values: @role_values, default: :USER
    timestamps()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @fields)
    |> update_change(:email, &String.downcase/1)
    |> update_change(:user_name, &String.upcase/1)
    |> validate_format(:email, ~r/@/, message: "has invalid format please type a valid e-mail")
    |> validate_length(:password,
      min: 6,
      max: 100,
      message: "password should have between 6 to 100 chars"
    )
    |> hash_password()
    |> validate_confirmation(:password)
    |> unique_constraint(:drive_license)
    |> unique_constraint(:email)
    |> unique_constraint(:user_name)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @fields)
    |> update_change(:email, &String.downcase/1)
    |> update_change(:user_name, &String.upcase/1)
    |> validate_format(:email, ~r/@/, message: "has invalid format please type a valid e-mail")
    |> validate_length(:password,
      min: 6,
      max: 100,
      message: "password should have between 6 to 100 chars"
    )
    |> hash_password()
    |> validate_confirmation(:password)
    |> validate_required(@required_fields)
    |> unique_constraint(:drive_license)
    |> unique_constraint(:email)
    |> unique_constraint(:user_name)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
