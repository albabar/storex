defmodule StorexWeb.Helpers.PriceFormatter do
  def format_price(%Decimal{}=price) do
    "$#{price}"
  end

  def format_price(price), do: price
end
