defmodule DealerScraper.ReviewParser do
  @moduledoc """
  Defines a dealer parser.
  """
  alias DealerScraper.Rating
  alias DealerScraper.Review

  @doc """
  Parse a html content into a Review list.
  """
  @spec parse(binary()) :: [Review.t()]

  def parse(content) when is_bitstring(content) do
    content
    |> Floki.parse_document!()
    |> parse_reviews()
  end

  defp parse_reviews(document) do
    document
    |> Floki.find(".review-entry")
    |> Enum.map(fn review_fragment ->
      %Review{}
      |> Map.put(:title, parse_title(review_fragment))
      |> Map.put(:body, parse_body(review_fragment))
      |> Map.put(:user, parse_user(review_fragment))
      |> Map.put(:date, parse_date(review_fragment))
      |> put_recommend_dealer_and_rating(review_fragment)
    end)
  end

  defp parse_title(review_fragment) do
    review_fragment
    |> Floki.find("h3")
    |> Floki.text()
    |> String.replace(["\n", "\""], "")
    |> String.trim()
  end

  defp parse_body(review_fragment) do
    review_fragment
    |> Floki.find("p")
    |> Floki.text()
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.join("\n")
  end

  defp parse_user(review_fragment) do
    review_fragment
    |> Floki.find("span")
    |> Enum.at(0)
    |> Floki.text()
    |> String.replace("- ", "")
  end

  defp parse_date(review_fragment) do
    review_fragment
    |> Floki.find(".review-date div")
    |> Enum.at(0)
    |> Floki.text()
  end

  defp put_recommend_dealer_and_rating(review, review_fragment) do
    [recommend_fragment | rating_fragment] =
      review_fragment
      |> Floki.find(".review-ratings-all .table .tr")
      |> Enum.reverse()

    review
    |> Map.put(:rating, parse_ratings(rating_fragment))
    |> Map.put(:recommend_dealer, parse_recommend_dealer(recommend_fragment))
  end

  defp parse_ratings(rating_fragment) do
    rating =
      Enum.map(rating_fragment, fn rating ->
        name =
          rating
          |> Floki.find(".td.small-text")
          |> Floki.text()
          |> String.split(" ")
          |> Enum.map(&String.downcase/1)
          |> Enum.join("_")
          |> String.to_existing_atom()

        rating =
          rating
          |> Floki.find(".td.rating-static-indv")
          |> Floki.attribute("class")
          |> Floki.text()
          |> String.replace(~r/.*rating-(\d{1,2}).*/, "\\g{1}")
          |> String.to_integer()

        {name, rating}
      end)
      |> Map.new()

    struct(Rating, rating)
  end

  defp parse_recommend_dealer(recommend_fragment) do
    recommend_fragment
    |> Floki.text()
    |> String.upcase()
    |> String.contains?("YES")
  end
end
