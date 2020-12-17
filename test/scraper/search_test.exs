defmodule DealerScraper.SearchTest do
  use ExUnit.Case, async: false

  doctest DealerScraper.Search

  alias DealerScraper.Search

  describe "get_dealer_link/1" do
    test "should return a valid link" do
      bypass = Bypass.open()

      Bypass.expect_once(bypass, fn conn ->
        Plug.Conn.resp(
          conn,
          200,
          Jason.encode!([
            %{"dealerName" => "Searched dealer", "dealerId" => 1}
          ])
        )
      end)

      result = Search.get_dealer_link("Dealer", "http://localhost:#{bypass.port}")

      assert {:ok, link} = result
      assert "http://localhost:#{bypass.port}/dealer/Searched-dealer-dealer-reviews-1" == link
    end

    test "should return an error when dealer not exists" do
      bypass = Bypass.open()

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, "[]")
      end)

      result = Search.get_dealer_link("I don't exists", "http://localhost:#{bypass.port}")

      assert {:error, :dealer_not_found} == result
    end

    test "should return an error when status code is not 200" do
      bypass = Bypass.open()

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 404, "[]")
      end)

      result = Search.get_dealer_link("I don't exists", "http://localhost:#{bypass.port}")

      assert {:error, :unable_to_search} == result
    end
  end
end
