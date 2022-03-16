defmodule RentCartsWeb.CarView do
  use RentCartsWeb, :view

  def render("show.json", %{car: car}) do
    %{data: render_one(car, __MODULE__, "car.json")}
  end

  def render("car.json", %{car: car}) do
    %{
      name: car.name,
      description: car.description,
      brand: car.brand,
      daily_rate: car.daily_rate,
      license_plate: car.license_plate,
      fine_amount: car.fine_amount,
      category_id: car.category_id
    }
  end
end
