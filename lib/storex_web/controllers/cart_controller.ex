defmodule StorexWeb.CartController do
  use StorexWeb, :controller
  alias StorexWeb.Plugs.FetchCart
  import Storex.Store, only: [find_book: 1]
  import Storex.Sales, only: [add_book_to_cart: 2, list_line_items: 1, line_items_total_price: 1, remove_book_from_cart: 2]

  def show(conn, _params) do
    cart = FetchCart.get(conn)
    items = list_line_items(cart)
    total_price = line_items_total_price(cart)
    render conn, "show.html", items: items, total: total_price
  end

  def create(conn, %{"book_id" => book_id}) do
    cart = FetchCart.get(conn)
    book = find_book(book_id)
    add_book_to_cart(book, cart)

    redirect(conn, to: Routes.cart_path(conn, :show))
  end

  def delete(conn, %{"book_id" => book_id}) do
    cart = FetchCart.get(conn)
    book = find_book(book_id)
    remove_book_from_cart(book, cart)

    redirect(conn, to: Routes.cart_path(conn, :show))
  end
end
