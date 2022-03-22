defmodule RentCarts.Shared.DateValidations do
  def is_more_than_24_hours?(end_date) do
    end_date
    |> NaiveDateTime.from_iso8601!()
    |> Timex.diff(NaiveDateTime.utc_now(), :days)
    |> return_message()
  end

  def return_message(value) when value > 0,  do: :ok
  def return_message(_value), do: {:error, :message, "Invalid return date"}
end
