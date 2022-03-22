defmodule RentCartsWeb.RentalController do
  use RentCartsWeb, :controller

  alias RentCarts.Rentals

  action_fallback RentCartsWeb.FallbackController

  def create(conn, %{"car_id" => car_id, "expected_return_date" => expected_return_date}) do
    [user_id] = get_req_header(conn, "user_id")

    with {:ok, %{insert_rental: rental}} <-
           Rentals.create_rentals(car_id, user_id, expected_return_date) do
      conn
      |> put_status(:created)
      |> render("show.json", rental: rental)
    end
  end
end
