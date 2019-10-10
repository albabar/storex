defmodule StorexWeb.CheckoutController do
  use StorexWeb, :controller
  alias Storex.Sales
  alias StorexWeb.Plugs.{FetchCart, EnsureCurrentUser, CurrentUser}

  plug EnsureCurrentUser

  def new(conn, _param) do
    conn |> with_cart_info |> render("new.html", changeset: Sales.new_order())
  end

  def create(conn, %{"order" => order_params}) do
    cart = FetchCart.get(conn)
    user = CurrentUser.get(conn)

    case Sales.process_order(user, cart, order_params) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Order Successfully created! Thanks!")
        |> FetchCart.forget
        |> redirect(to: Routes.book_path(conn, :index))
        |> halt
      {:error, changeset} ->
        conn |> with_cart_info |> render("new.html", changeset: changeset)
    end
  end

  defp with_cart_info(conn) do
    cart = FetchCart.get(conn)
    items_count = Sales.line_items_count(cart)
    total_price = Sales.line_items_total_price(cart)

    conn |> assign(:items_count, items_count) |> assign(:total_price, total_price)
  end
end
