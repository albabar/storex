defmodule StorexWeb.Plugs.EnsureCurrentUser do
  alias Phoenix.Controller

  def init(opts), do: opts 

  def call(conn, _opts) do
    if StorexWeb.Plugs.CurrentUser.get(conn) do
      conn
    else
      conn
      |> Controller.put_flash(:error, "Sign in/up to continue")
      |> Controller.redirect(to: StorexWeb.Router.Helpers.session_path(conn, :new))
    end
  end
end
