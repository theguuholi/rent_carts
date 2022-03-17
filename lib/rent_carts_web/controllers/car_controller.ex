defmodule RentCartsWeb.CarController do
  use RentCartsWeb, :controller

  alias RentCarts.Cars
  alias RentCarts.Cars.Car

  action_fallback RentCartsWeb.FallbackController

  def create(conn, %{"car" => car}) do
    with {:ok, %Car{} = car} <- Cars.create_car(car) do
      conn
      |> put_status(:created)
      |> render("show.json", car: car)
    end
  end
end
