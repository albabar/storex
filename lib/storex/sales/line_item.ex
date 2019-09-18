defmodule Storex.Sales.LineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_line_items" do
    belongs_to :book, Storex.Store.Book
    belongs_to :cart, Storex.Sales.Cart
    field :quantity, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
