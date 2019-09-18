defmodule Storex.Store.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "store_books" do
    field :description, :string
    field :image_url, :string
    field :price, :decimal
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :description, :price, :image_url])
    |> validate_required([:title, :description, :price, :image_url])
    |> validate_max_price()
  end

  def validate_max_price(changeset) do
    if Decimal.cmp(get_change(changeset, :price), 100) == :gt do
      add_error(changeset, :price, "Price must be under 100")
    else
      changeset
    end
  end
end
