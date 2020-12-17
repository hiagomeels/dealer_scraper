defmodule DealerScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :dealer_scraper,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:floki, "~> 0.29.0"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.23.0", only: :dev},
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:bypass, "~> 2.1", only: [:dev, :test]},
      {:excoveralls, "~> 0.13.3", only: [:dev, :test]}
    ]
  end
end
