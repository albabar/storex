defmodule Storex.Sales do
  import Ecto.Query, warn: false
  alias Storex.Repo
  alias Storex.Sales.{Order, Cart, LineItem}

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

  def new_order do
    Order.changeset(%Order{}, %{})
  end

  defp create_order(user, attrs) do
    %Order{user_id: user.id} |> Order.changeset(attrs) |> Repo.insert
  end

  defp create_order_line_items(order, cart) do
    line_items = list_line_items(cart)
    order_line_items = Enum.map(line_items, fn item ->
      Ecto.build_assoc(order, :line_items, %{book_id: item.book_id, quantity: item.quantity}) |> Repo.insert!
    end)

    {:ok, order_line_items}
  end

  def process_order(user, cart, attrs) do
    result = Ecto.Multi.new
             |> Ecto.Multi.run(:order, fn(_, _) -> create_order(user, attrs) end)
             |> Ecto.Multi.run(:line_items, fn(_, %{order: order}) -> create_order_line_items(order, cart) end)
             |> Repo.transaction

    case result do
      {:ok, %{order: order}} -> {:ok, Repo.preload(order, [:user, :line_items])}
      {:error, :order, changeset, _} -> {:error, changeset}
    end
  end
end
