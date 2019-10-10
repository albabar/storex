defmodule StorexWeb.Plugs.AdminOnly do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if StorexWeb.Plugs.CurrentUser.is_admin?(conn) do
      conn
    else
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(:forbidden, "Not Allowed")
      |> halt
    end
  end
end
