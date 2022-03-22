defmodule RentCarts.Shared.DateValidations do
  def is_more_than_24_hours?(end_date) do
    end_date
    |> NaiveDateTime.from_iso8601!()
    |> Timex.diff(NaiveDateTime.utc_now(), :days)
    |> then(&(&1 > 0))
  end
end
