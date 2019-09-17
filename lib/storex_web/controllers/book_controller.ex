defmodule StorexWeb.BookController do
  use StorexWeb, :controller
  alias Storex.Store

  def index(conn, _params) do
    render conn, "index.html", books: Store.list_books()
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", book: Store.find_book(id |> String.to_integer)
  end
end
