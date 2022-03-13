defmodule RentCartsWeb.SessionView do
  use RentCartsWeb, :view
  alias RentCartsWeb.UserView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, __MODULE__, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{
      user: UserView.render("show.json", user: session.user),
      token: session.token
    }
  end
end
