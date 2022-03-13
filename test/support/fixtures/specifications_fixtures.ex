defmodule RentCarts.SpecificationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RentCarts.Specifications` context.
  """

  @doc """
  Generate a unique specification name.
  """
  def unique_specification_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a specification.
  """
  def specification_fixture(attrs \\ %{}) do
    {:ok, specification} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: unique_specification_name()
      })
      |> RentCarts.Specifications.create_specification()

    specification
  end
end
