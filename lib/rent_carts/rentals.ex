defmodule RentCarts.Rentals do
  alias RentCarts.Cars

  def create_rentals(car_id, user_id) do
    car_id
    |> Cars.is_car_avilable?()
    |> return_car_available()
    |> check_is_user_has_a_rental(user_id)
  end

  defp return_car_available({true, car_id}), do: car_id
  defp return_car_available({false, _}), do: {:error, :message, "Car is unavailable"}

  defp check_is_user_has_a_rental({:error, _, _} = err, _user_id), do: err

  defp check_is_user_has_a_rental(_car_id, _user_id) do
    {:error, :message, "User has a a car reservade"}
  end
end
