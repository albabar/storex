defmodule StorexWeb.BookController do
  use StorexWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", books: list_books()
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", book: find_book(id |> String.to_integer)
  end

  def find_book(id) do
    list_books() |> Enum.find(fn book -> book.id == id end)
  end

  def list_books() do
    [
      %{
        id: 1,
        title: "My First Book",
        description: "Love story",
        price: 15.9,
        image_url: "https://www.phoenixforrailsdevelopers.com/books/1.png"
      },
      %{
        id: 2,
        title: "My Second Book",
        description: "Adventure story",
        price: 25.8,
        image_url: "https://www.phoenixforrailsdevelopers.com/books/2.png"
      },
      %{
        id: 3,
        title: "My Third Book",
        description: "Spy story",
        price: 35.8,
        image_url: "https://www.phoenixforrailsdevelopers.com/books/3.png"
      },
      %{
        id: 4,
        title: "My Fourth Book",
        description: "Thriller story",
        price: 45.8,
        image_url: "https://www.phoenixforrailsdevelopers.com/books/4.png"
      }
    ]
  end
end
