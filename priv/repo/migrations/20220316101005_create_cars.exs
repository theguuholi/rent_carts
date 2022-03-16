defmodule RentCarts.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :daily_rate, :integer
      add :available, :boolean, default: true, null: false
      add :license_plate, :string
      add :fine_amount, :integer
      add :brand, :string

      add :category_id,
          references(:categories, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      timestamps()
    end

    create index(:cars, [:category_id])
  end
end
