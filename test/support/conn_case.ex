defmodule RentCartsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use RentCartsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL.Sandbox
  alias RentCarts.AccountsFixtures
  alias RentCarts.Sessions

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import RentCartsWeb.ConnCase

      alias RentCartsWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint RentCartsWeb.Endpoint
    end
  end

  setup tags do
    pid = Sandbox.start_owner!(RentCarts.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def include_normal_token_user(%{conn: conn}) do
    user = AccountsFixtures.user_fixture()
    {:ok, _, token} = Sessions.create(user.email, user.password)

    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)
    {:ok, conn: conn, user: user, token: token}
  end

  def include_admin_token(%{conn: conn}) do
    user = AccountsFixtures.user_admin_fixture()
    {:ok, _, token} = Sessions.create(user.email, user.password)

    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)
    {:ok, conn: conn, user: user, token: token}
  end
end
