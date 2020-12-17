defmodule Mix.Tasks.OverlyPositiveTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO
  import BypassHelper

  alias DealerScraper.Config
  alias Mix.Tasks.OverlyPositive

  @expected_output File.read!("./test/assets/output_console")

  describe "get/1" do
    test "should be output print most the three most “overly positive” reviews" do
      dealer = "Searched dealer"
      bypass = configure_bypass(dealer, 1..5)

      config_base_url = Config.base_url()
      Application.put_env(:dealer_scraper, :base_url, "http://localhost:#{bypass.port}")

      output =
        capture_io(fn ->
          args = ["--dealer", dealer, "-s", "1", "-e", "5"]
          OverlyPositive.run(args)
        end)

      Application.put_env(:dealer_scraper, :base_url, config_base_url)

      assert output == @expected_output
    end

    test "should display an error when the dealer parameter is missing" do
      assert_raise Mix.Error, "The dealer parameter is required", fn ->
        OverlyPositive.run([])
      end
    end
  end
end
