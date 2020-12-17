defmodule DealerScraper.Config do
  @moduledoc """
  Provides an easy way to access the application configuration.
  """

  @doc """
  Gets a base url from configuration.

  ## Examples

  iex> DealerScraper.Config.base_url()
  "https://www.dealerrater.com"
  """
  def base_url do
    Application.fetch_env!(:dealer_scraper, :base_url)
  end
end
