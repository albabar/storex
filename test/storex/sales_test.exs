defmodule Storex.SalesTest do
  use Storex.DataCase
  alias Storex.{Store, Sales}

  describe "carts" do
    alias Storex.Sales.Cart

    def book_fixture(attrs \\ %{}) do
      default_attrs = %{
        title: "Title",
        description: "Best Book",
        image_url: "product.png",
        price: 69
      }
      {:ok, book} = attrs |> Enum.into(default_attrs) |> Store.create_book()
      book
    end

    def cart_fixture do
      {:ok, cart} = Sales.create_cart()
      cart
    end

    test "create_cart/0 creates a cart" do
      assert {:ok, %Cart{}} = Sales.create_cart
    end

    test "get_cart!/1 finds a cart" do
      cart = cart_fixture()
      assert Sales.get_cart!(cart.id) == cart
    end

    test "get_cart!/1 raises error if not found" do
      assert_raise Ecto.NoResultsError, fn -> Sales.get_cart!(123) end
    end

    test "add_book_to_cart/2 creates or increments a line_item" do
      book = book_fixture()
      cart = cart_fixture()
      {:ok, line_item1} = Sales.add_book_to_cart(book, cart)
      {:ok, line_item2} = Sales.add_book_to_cart(book, cart)

      assert line_item1.quantity == 1
      assert line_item1.book_id == book.id
      assert line_item1.cart_id == cart.id
      assert line_item1.id == line_item2.id
      assert line_item2.quantity == 2
    end

    test "remove_book_from_cart/2 remove or decrements a line_item" do
      book = book_fixture()
      cart = cart_fixture()
      Sales.add_book_to_cart(book, cart)
      Sales.add_book_to_cart(book, cart)

      {:ok, line_item} = Sales.remove_book_from_cart(book, cart)
      assert line_item.quantity == 1

      Sales.remove_book_from_cart(book, cart)
      assert_raise Ecto.NoResultsError, fn ->
        Sales.remove_book_from_cart(book, cart)
      end
    end

    test "list_line_items/1 gets the list of line items of a cart" do
      book1 = book_fixture()
      book2 = book_fixture(%{title: "Book 2", price: 39})
      cart1 = cart_fixture()
      cart2 = cart_fixture()

      Sales.add_book_to_cart(book1, cart1)
      Sales.add_book_to_cart(book2, cart2)

      [line_item1] = Sales.list_line_items(cart1)
      assert line_item1.book_id == book1.id

      [line_item2] = Sales.list_line_items(cart2)
      assert line_item2.book_id == book2.id
    end

    test "line_items_count/1 gets the total quantity of a cart" do
      book1 = book_fixture()
      book2 = book_fixture(%{title: "Book 2", price: 39})
      cart = cart_fixture()

      Sales.add_book_to_cart(book1, cart)
      Sales.add_book_to_cart(book2, cart)
      Sales.add_book_to_cart(book1, cart)

      assert Sales.line_items_count(cart) == 3
    end

    test "line_items_total_price/1 gets the total quantity of a cart" do
      book1 = book_fixture()
      book2 = book_fixture(%{title: "Book 2", price: 39})
      cart = cart_fixture()

      Sales.add_book_to_cart(book1, cart)
      Sales.add_book_to_cart(book2, cart)
      Sales.add_book_to_cart(book1, cart)

      assert Sales.line_items_total_price(cart) == Decimal.new("177.00")
    end
  end
end
