defmodule StorexWeb.SessionController do
  use StorexWeb, :controller
  alias Storex.Accounts
  alias StorexWeb.Plugs.CurrentUser

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"credentials" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> CurrentUser.set(user)
        |> put_flash(:info, "Welcome to Storex")
        |> redirect(to: Routes.cart_path(conn, :show))
      {:error, _} ->
        conn |> put_flash(:error, "Login failed") |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn |> CurrentUser.forget |> redirect(to: Routes.book_path(conn, :index))
  end
end
