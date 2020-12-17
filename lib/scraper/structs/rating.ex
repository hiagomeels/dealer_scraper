defmodule DealerScraper.Rating do
  @moduledoc """
  Defines a rating struct
  """

  defstruct customer_service: 0,
            friendliness: 0,
            overall_experience: 0,
            pricing: 0,
            quality_of_work: 0

  @type t() :: %__MODULE__{
          customer_service: integer(),
          friendliness: integer(),
          overall_experience: integer(),
          pricing: integer(),
          quality_of_work: integer()
        }
end
