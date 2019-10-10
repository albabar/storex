defmodule StorexWeb.BookController do
  use StorexWeb, :controller
  alias Storex.Store
  alias Storex.Store.Book

  plug StorexWeb.Plugs.AdminOnly when action not in [:index, :show]

  def index(conn, _params) do
    render conn, "index.html", books: Store.list_books()
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", book: Store.find_book(id |> String.to_integer)
  end

  def new(conn, _params) do
    #render conn, "new.html", changeset: Store.change_book(%{price: 0.0})
    render conn, "new.html", changeset: Book.changeset(%Book{}, %{price: 0})
  end

  def create(conn, %{"book" => book_params}) do
    case Store.create_book(book_params) do
      {:ok, _book} ->
        conn |> put_flash(:info, "Book Has been successfully created") |> redirect(to: "/")
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => book_id}) do
    book = Store.find_book(book_id)
    changeset = Store.change_book(book)
    render conn, "edit.html", book: book, changeset: changeset
  end

  def update(conn, %{"id" => book_id, "book" => book_params}) do
    book = Store.find_book(book_id)
    case Store.update_book(book, book_params) do
      {:ok, _book} ->
        conn |> put_flash(:info, "Book updated") |> redirect(to: "/")
      {:error, changeset} ->
        render conn, "edit.html", book: book, changeset: changeset
    end
  end

  def delete(conn, %{"id" => book_id}) do
    Store.find_book(book_id) |> Store.delete_book

    conn |> put_flash(:info, "Book Deleted") |> redirect(to: "/")
  end
end
