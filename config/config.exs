# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :bypass, test_framework: :espec

config :dealer_scraper,
  base_url: "https://www.dealerrater.com"
