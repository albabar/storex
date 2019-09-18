defmodule Storex.Sales do
  import Ecto.Query, warn: false
  alias Storex.Repo
  alias Storex.Sales.{Cart, LineItem}

  def create_cart(attrs \\ %{}) do
    %Cart{} |> Cart.changeset(attrs) |> Repo.insert
  end

  def get_cart!(id) do
    Repo.get!(Cart, id)
  end

  def add_book_to_cart(book, cart) do
    line_item = Repo.get_by(LineItem, book_id: book.id, cart_id: cart.id)
    if line_item do
      line_item
      |> LineItem.changeset(%{quantity: line_item.quantity + 1})
      |> Repo.update
    else
      %LineItem{book_id: book.id, cart_id: cart.id, quantity: 1}
      |> LineItem.changeset(%{}) |> Repo.insert
    end
  end

  def remove_book_from_cart(book, cart) do
    line_item = Repo.get_by!(LineItem, book_id: book.id, cart_id: cart.id)

    if line_item.quantity > 1 do
      line_item
      |> LineItem.changeset(%{quantity: line_item.quantity - 1})
      |> Repo.update
    else
      line_item |> Repo.delete!
    end
  end

  def list_line_items(cart) do
    LineItem |> Ecto.Query.where(cart_id: ^cart.id) |> preload(:book) |> Repo.all
  end

  def line_items_count(cart) do
    list_line_items(cart) |> Enum.reduce(0, fn(item, acc) -> acc + item.quantity end)
  end

  def line_items_total_price(cart) do
    list_line_items(cart)
    |> Enum.reduce(0, fn(item, acc) ->
      item.quantity |> Decimal.mult(item.book.price) |> Decimal.add(acc)
    end)
  end
end
