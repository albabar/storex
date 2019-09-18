defmodule Storex.Store do
  alias Storex.Repo
  alias Storex.Store.Book

  def find_book(id) do
    Book |> Repo.get(id)
  end

  def list_books() do
    Book |> Repo.all
  end

  def create_book(attrs) do
    %Book{} |> Book.changeset(attrs) |> Repo.insert
  end
end
