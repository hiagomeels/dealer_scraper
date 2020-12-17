defmodule DealerScraper.Search do
  @moduledoc """
  Provides a search and creation of link to handle with dealer reviews.
  """

  alias DealerScraper.Config
  alias HTTPoison.Response

  @doc """
  Gets a link of a dealer if exists.
  """

  @spec get_dealer_link(binary(), binary()) ::
          {:ok, binary()} | {:error, :unable_to_search} | {:error, :dealer_not_found}

  def get_dealer_link(dealer, base_url \\ nil) do
    term = String.replace(dealer, " ", "+")

    base_url = base_url || Config.base_url()
    url = "#{base_url}/json/dealer/dealersearch?MaxItems=1&term=#{term}"

    headers = [{"Referer", "#{Config.base_url()}/reviews/"}]

    url
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode()
        |> build_link(base_url)

      _ ->
        {:error, :unable_to_search}
    end
  end

  defp build_link({:ok, [%{"dealerName" => dealer_name, "dealerId" => id}]}, base_url) do
    base_url = "#{base_url}/dealer/"

    dealer_name =
      dealer_name
      |> String.replace(~r/\-\s/, "")
      |> String.replace(" ", "-")

    {:ok, "#{base_url}#{dealer_name}-dealer-reviews-#{id}"}
  end

  defp build_link(_search_result, _base_url), do: {:error, :dealer_not_found}
end
