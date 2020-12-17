defmodule Mix.Tasks.OverlyPositive do
  @moduledoc """
  Outputs the three most “overly positive” reviews to the console, in order of severity

  ## Examples
      mix overly_positive --dealer "McKaig Chevrolet Buick"
      mix overly_positive -d "McKaig Chevrolet Buick"

  ## Command line options

    * `-d`, `--dealer` - the dealer to search
    * `-s`, `--start_page` - the start page to fetch
    * `-e`, `--end_page` - the end page to fetch

  """
  use Mix.Task

  alias DealerScraper.Review

  @requirements ["app.start"]

  @shortdoc "Outputs the three most “overly positive” reviews"

  @default_opts [start_page: 1, end_page: 1]

  @switches [
    dealer: :string,
    start_page: :integer,
    end_page: :integer
  ]

  @aliases [
    d: :dealer,
    s: :start_page,
    e: :end_page
  ]

  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)
    opts = Keyword.merge(@default_opts, opts)

    dealer = opts[:dealer] || Mix.raise("The dealer parameter is required")
    start_page = opts[:start_page]
    end_page = opts[:end_page]

    {:ok, reviews} = DealerScraper.get(dealer, start_page..end_page)

    IO.puts("""
    The three most “overly positive” reviews is:
    """)

    reviews
    |> DealerScraper.sort_by_overly_positive()
    |> Enum.take(3)
    |> Enum.with_index()
    |> Enum.each(&print/1)
  end

  defp print({%Review{} = review, index}) do
    header = pad_both(" #{index + 1}° Review ", 50, "-")

    IO.puts("""
    #{header}

    Reviewer: #{review.user}
    Date: #{review.date}

    #{review.title}

    Ratings:
        CUSTOMER SERVICE:    #{review.rating.customer_service / 10}
        QUALITY OF WORK:     #{review.rating.friendliness / 10}
        FRIENDLINESS:        #{review.rating.overall_experience / 10}
        PRICING:             #{review.rating.pricing / 10}
        OVERALL EXPERIENCE:  #{review.rating.quality_of_work / 10}
        RECOMMEND DEALER:    #{if review.recommend_dealer, do: "YES", else: "NO"}

    #{review.body}

    """)
  end

  defp pad_both(str, count, padding) do
    :string.pad(str, count, :both, padding)
  end
end
