defmodule RentCarts.Shared.DateValidationsTest do
  use RentCarts.DataCase
  alias RentCarts.Shared.DateValidations

  test "should throw error if data is less than 24 hours" do
    end_date =
      NaiveDateTime.utc_now() |> then(&%{&1 | hour: &1.hour + 5}) |> NaiveDateTime.to_string()

    assert {:error, :message, "Invalid return date"} ==
             DateValidations.is_more_than_24_hours?(end_date)
  end

  test "should data is more than 24 hours" do
    end_date =
      NaiveDateTime.utc_now() |> then(&%{&1 | day: &1.day + 4}) |> NaiveDateTime.to_string()

    assert :ok == DateValidations.is_more_than_24_hours?(end_date)
  end
end
