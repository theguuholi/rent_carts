defmodule RentCarts.Rentals do
  alias RentCarts.Rentals.Core.CreateRental

  defdelegate create_rentals(car_id, user_id, expected_return_date),
    to: CreateRental,
    as: :execute
end
