defmodule StorexWeb.LayoutView do
  use StorexWeb, :view

  def items_count(conn) do
    StorexWeb.Plugs.FetchCart.items_count(conn)
  end

  def items_total_price(conn) do
    StorexWeb.Plugs.FetchCart.total_price(conn)
  end
end
