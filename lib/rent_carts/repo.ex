defmodule RentCarts.Repo do
  use Ecto.Repo,
    otp_app: :rent_carts,
    adapter: Ecto.Adapters.Postgres
end
