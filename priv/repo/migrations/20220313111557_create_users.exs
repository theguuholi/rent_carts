defmodule RentCarts.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE roles AS ENUM ('USER', 'ADMIN')"
    drop_query = "DROP TYPE roles"

    execute(create_query, drop_query)

    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :user_name, :string
      add :password_hash, :string
      add :email, :string
      add :drive_license, :string
      add :role, :roles, default: "USER", null: false

      timestamps()
    end

    create unique_index(:users, [:drive_license])
    create unique_index(:users, [:email])
    create unique_index(:users, [:user_name])
  end
end
