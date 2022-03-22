defmodule RentCarts.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Waffle.Ecto.Schema
  alias __MODULE__.UserPhoto

  @fields ~w/role/a
  @required_fields ~w/name user_name password password_confirmation email drive_license/a
  @role_values ~w(USER ADMIN)a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :drive_license, :string
    field :email, :string
    field :name, :string
    field :photo_url, UserPhoto.Type
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :user_name, :string
    field :role, Ecto.Enum, values: @role_values, default: :USER
    has_many :rentals, RentCarts.Rentals.Data.Rental
    timestamps()
  end

  def update_photo(user, attrs) do
    cast_attachments(user, attrs, [:photo_url])
  end

  def update_changeset(user, attrs) do
    user
    |> default_changesets(attrs)
  end

  def changeset(user, attrs) do
    default_changesets(user, attrs)
  end

  def default_changesets(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/, message: "has invalid format please type a valid e-mail")
    |> validate_length(:password,
      min: 6,
      max: 100,
      message: "password should have between 6 to 100 chars"
    )
    |> hash_password()
    |> update_change(:email, &String.downcase/1)
    |> update_change(:user_name, &String.upcase/1)
    |> validate_confirmation(:password)
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
