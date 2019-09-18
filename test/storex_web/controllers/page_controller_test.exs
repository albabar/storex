defmodule StorexWeb.PageControllerTest do
  use StorexWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Storex"
  end
end
