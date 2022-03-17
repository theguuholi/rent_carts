defmodule RentCartsWeb.Router do
  use RentCartsWeb, :router
  alias RentCartsWeb.Middlewares.EnsureAuthenticated
  alias RentCartsWeb.Middlewares.IsAdmin

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RentCartsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :is_admin do
    plug(IsAdmin)
  end

  pipeline :auth do
    plug(EnsureAuthenticated)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RentCartsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", RentCartsWeb do
    pipe_through [:api, :is_admin]
    post "/cars", CarController, :create
  end

  scope "/api", RentCartsWeb do
    pipe_through [:api, :auth]
    post "/sessions/me", SessionController, :me
    resources "/categories", CategoryController, except: [:new, :edit]
    resources "/specifications", SpecificationController, except: [:new, :edit]
    patch "/users/photo", UserController, :update_foto
    resources "/users", UserController, except: [:new, :edit, :create]
  end

  scope "/api", RentCartsWeb do
    pipe_through :api
    post "/users", UserController, :create
    post "/sessions", SessionController, :create
    get "/cars", CarController, :index
  end

  # coveralls-ignore-start
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RentCartsWeb.Telemetry
    end
  end

  # coveralls-ignore-stop

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
