defmodule DealerScraper do
  @moduledoc """
  Defines a dealer scraper.
  """

  alias DealerScraper.Config
  alias DealerScraper.Rating
  alias DealerScraper.Review
  alias DealerScraper.ReviewParser
  alias DealerScraper.Search

  @doc """
  Gets Dealer reviews from www.dealerrater.com parsed into a list of `DealerScraper.Review`.
  """

  @spec get(binary(), Range.t(), binary()) ::
          {:ok, [Review.t()]}
          | {:error, :dealer_not_found}
          | {:error, :unable_to_fetch_page}
          | {:error, :dealer_not_found}
          | {:error, :unable_to_search}

  def get(dealer, pages, base_url \\ nil) do
    base_url = base_url || Config.base_url()

    dealer
    |> Search.get_dealer_link(base_url)
    |> get_reviews(pages)
  end

  defp get_reviews({:ok, dealer_url}, pages) do
    reviews =
      pages
      |> Task.async_stream(&get_reviews_from_url(dealer_url, &1))
      |> Enum.map(fn {:ok, enum} -> enum end)
      |> Enum.concat()

    {:ok, reviews}
  rescue
    _ -> {:error, :unable_to_fetch_page}
  end

  defp get_reviews({:error, error}, _pages), do: {:error, error}

  defp get_reviews_from_url(dealer_url, page) do
    "#{dealer_url}/page#{page}?filter=ONLY_POSITIVE"
    |> HTTPoison.get()
    |> case do
      {:ok, %{status_code: 200, body: body}} ->
        ReviewParser.parse(body)

      _ ->
        {:error, :unable_to_fetch_page}
    end
  end

  @doc """
  Sorts the reviews by overly positive reviews.

  The criteria for sorting is the best rated (sum of rating values / count of ratings) first.
  """
  def sort_by_overly_positive(reviews) do
    Enum.sort(reviews, fn a, b ->
      rating_a = calculate_rating(a.rating)
      rating_b = calculate_rating(b.rating)

      rating_a > rating_b
    end)
  end

  defp calculate_rating(%Rating{} = rating) do
    ratings =
      rating
      |> Map.values()
      |> Enum.filter(&is_integer/1)

    count = Enum.count(ratings)
    sum = Enum.sum(ratings)

    sum / count
  end
end
