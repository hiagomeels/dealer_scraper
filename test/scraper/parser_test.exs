defmodule DealerScraper.ParserTest do
  use ExUnit.Case

  alias DealerScraper.Rating
  alias DealerScraper.Review
  alias DealerScraper.ReviewParser

  @dealer_page_content File.read!("./test/assets/dealer_page.html")
  @review_entry_content File.read!("./test/assets/review_entry.html")

  describe "parse/1" do
    test "should return a list of reviews" do
      reviews = ReviewParser.parse(@dealer_page_content)

      assert is_list(reviews)
      assert Enum.count(reviews) === 10

      Enum.each(reviews, fn review ->
        assert %Review{} = review
      end)
    end

    test "review attrs should be populated" do
      assert [%Review{} = review] = ReviewParser.parse(@review_entry_content)

      assert review.title == "Title"
      assert review.user == "user"
      assert review.recommend_dealer == true

      assert review.body == """
             Lorem ipsum dolor sit amet, consectetur adipiscing elit.
             Vestibulum urna mi, porttitor vel turpis sed, venenatis semper quam.
             """

      assert review.rating == %Rating{
               customer_service: 1,
               friendliness: 5,
               overall_experience: 40,
               pricing: 50,
               quality_of_work: 10
             }
    end

    test "should return an empty list when given an empty content" do
      content = ""
      assert [] == ReviewParser.parse(content)
    end
  end
end
