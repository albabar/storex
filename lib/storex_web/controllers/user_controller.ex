defmodule StorexWeb.UserController do
  use StorexWeb, :controller
  alias StorexWeb.Plugs.CurrentUser

  def new(conn, _params) do
    changeset = Storex.Accounts.new_user()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Storex.Accounts.create_user(user_params) do
      {:ok, user} -> conn |> CurrentUser.set(user) |> redirect(to: Routes.cart_path(conn, :show))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
end
