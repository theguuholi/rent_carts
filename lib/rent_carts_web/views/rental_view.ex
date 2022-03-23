defmodule RentCartsWeb.RentalView do
  use RentCartsWeb, :view
  alias RentCartsWeb.CarView

  def render("index.json", %{rentals: rentals}) do
    %{data: render_many(rentals, __MODULE__, "rental.json")}
  end

  def render("show.json", %{rental: rental}) do
    %{data: render_one(rental, __MODULE__, "rental.json")}
  end

  def render("rental.json", %{rental: rental}) do
    car =
      (Ecto.assoc_loaded?(rental.car) &&
         CarView.render("show.json", %{car: rental.car})) || nil

    %{
      car: car,
      end_date: rental.end_date,
      expected_return_date: rental.expected_return_date,
      id: rental.id,
      start_date: rental.start_date,
      total: rental.total,
      user_id: rental.user_id
    }
  end
end
