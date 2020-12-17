defmodule DealerScraper.Review do
  @moduledoc """
  Defines a review struct
  """

  alias DealerScraper.Rating

  defstruct title: nil,
            body: nil,
            user: nil,
            date: nil,
            rating: %Rating{},
            recommend_dealer: false

  @type t() :: %__MODULE__{
          title: String.t() | nil,
          body: String.t() | nil,
          user: String.t() | nil,
          date: String.t() | nil,
          recommend_dealer: boolean(),
          rating: Rating.t()
        }
end
