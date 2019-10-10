defmodule Storex.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_orders" do
    field :address, :string
    has_many :line_items, Storex.Sales.LineItem
    belongs_to :user, Storex.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:address])
    |> validate_required([:address])
  end
end
