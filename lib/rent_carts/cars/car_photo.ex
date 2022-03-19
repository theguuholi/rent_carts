defmodule RentCarts.Cars.CarPhoto do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.png .jpeg .jpg .svg)

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(@extension_whitelist, file_extension) do
      true -> :ok
      false -> {:error, "file type is invalid"}
    end
  end

  def storage_dir(_, {_file, car}) do
    IO.inspect car
    "/uploads/cars"
  end
end
