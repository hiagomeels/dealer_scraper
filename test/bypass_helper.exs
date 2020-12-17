defmodule BypassHelper do
  @moduledoc false

  @dealer_page_content File.read!("./test/assets/dealer_page.html")

  def configure_bypass(dealer, pages, status_code \\ 200) do
    bypass = Bypass.open()

    Bypass.expect_once(bypass, "GET", "/json/dealer/dealersearch", fn conn ->
      result =
        Jason.encode!([
          %{
            "dealerName" => dealer,
            "dealerId" => 1
          }
        ])

      Plug.Conn.resp(conn, 200, result)
    end)

    dealer = String.replace(dealer, " ", "-")

    Enum.each(pages, fn page ->
      configure_dealer_page(bypass, dealer, page, status_code)
    end)

    bypass
  end

  defp configure_dealer_page(bypass, dealer, page, status_code) do
    Bypass.expect_once(
      bypass,
      "GET",
      "/dealer/#{dealer}-dealer-reviews-1/page#{page}",
      fn conn ->
        if status_code == 200 do
          Plug.Conn.resp(conn, 200, @dealer_page_content)
        else
          Plug.Conn.resp(conn, status_code, "")
        end
      end
    )
  end
end
