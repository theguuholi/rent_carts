defmodule RentCartsWeb.UserView do
  use RentCartsWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      user_name: user.user_name,
      email: user.email,
      role: user.role,
      drive_license: user.drive_license
    }
  end
end
