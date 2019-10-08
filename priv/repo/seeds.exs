# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Storex.Repo.insert!(%Storex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

books = [
  %{
    "title" => "Eating Well",
    "description" => "Healthy recipes for busy lifes",
    "price" => "39.00",
    "image_url" => "http://www.phoenixforrailsdevelopers.com/books/1.png"
   },
  %{
    "title" => "Lovely flowers to you",
    "description" => "The story about how flowers changed the world",
    "price" => "28.00",
    "image_url" => "http://www.phoenixforrailsdevelopers.com/books/2.png"
  },
  %{
    "title" => "My dog is my family hero",
    "description" => "Everything we have, we own to our dog",
    "price" => "35.00",
    "image_url" => "http://www.phoenixforrailsdevelopers.com/books/3.png"
  },
  %{
    "title" => "Just build it",
    "description" => "How to build a building",
    "price" => "23.00",
    "image_url" => "http://www.phoenixforrailsdevelopers.com/books/4.png"
  }
]

alias Storex.Store.Book
books |> Enum.each(fn book -> Storex.Repo.insert!(Book.changeset(%Book{}, book)) end)
