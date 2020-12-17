defmodule DealerScraperTest do
  use ExUnit.Case

  import BypassHelper

  alias DealerScraper.Rating
  alias DealerScraper.Review

  describe "get/1" do
    test "should return a list of reviews when all review pages exist" do
      pages = 1..5
      dealer = "Searched dealer"
      bypass = configure_bypass(dealer, pages)

      result = DealerScraper.get(dealer, pages, "http://localhost:#{bypass.port}")

      assert {:ok, reviews} = result
      assert is_list(reviews)
      assert Enum.count(reviews) === 50

      Enum.each(reviews, fn review ->
        assert %Review{} = review
      end)
    end

    test "should return a error when dealer page not exists" do
      pages = 1..1
      dealer = "Searched dealer 2"
      bypass = configure_bypass(dealer, pages, 404)

      result = DealerScraper.get(dealer, pages, "http://localhost:#{bypass.port}")

      assert {:error, :unable_to_fetch_page} == result
    end
  end

  describe "sort_by_overly_positive/1" do
    test "should be sort in proper way" do
      reviews = [
        %Review{
          title: "Title 1",
          rating: %Rating{
            customer_service: 0,
            friendliness: 0,
            overall_experience: 50,
            pricing: 50,
            quality_of_work: 50
          }
        },
        %Review{
          title: "Title 2",
          rating: %Rating{
            customer_service: 50,
            friendliness: 40,
            overall_experience: 50,
            pricing: 50,
            quality_of_work: 50
          }
        },
        %Review{
          title: "Title 3",
          rating: %Rating{
            customer_service: 50,
            friendliness: 50,
            overall_experience: 50,
            pricing: 50,
            quality_of_work: 50
          }
        }
      ]

      reviews_order_expected = [
        %Review{
          title: "Title 3",
          rating: %Rating{
            customer_service: 50,
            friendliness: 50,
            overall_experience: 50,
            pricing: 50,
            quality_of_work: 50
          }
        },
        %Review{
          title: "Title 2",
          rating: %Rating{
            customer_service: 50,
            friendliness: 40,
            overall_experience: 50,
            pricing: 50,
            quality_of_work: 50
          }
        },
        %Review{
          title: "Title 1",
          rating: %Rating{
            customer_service: 0,
            friendliness: 0,
            overall_experience: 50,
            pricing: 50,
            quality_of_work: 50
          }
        }
      ]

      assert reviews_order_expected === DealerScraper.sort_by_overly_positive(reviews)
    end
  end
end
