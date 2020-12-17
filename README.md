# DealerScraper

[![License? MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/hiagomeels/dealer_scraper/blob/main/LICENSE)

This project is a scraper to get reviews of a dealer from https://www.dealerrater.com.

## Assumptions

- The criteria for sorting is the best rated (sum of rating values / count of ratings) first.
- Always will be pass a valid html content to ReviewParser.

## TODO

- Extract more data from content like employees worked with.
- Improve data clean up.
- Work more on internet issues like add a retry in case of failure.
- Improve output comment in the most overly positive.
- Improve the Overly Positive task.

## Downloading and Running

This section explains how to download the project and run it.

To run this project you need to install elixir 1.11, [click here to see more](https://elixir-lang.org/install.html).

### Downloading

You can just clone or [download a zip file of the project](https://github.com/hiagomeels/dealer_scraper/archive/main.zip):

```BASH
git clone https://github.com/hiagomeels/dealer_scraper.git
cd dealer_scraper
```

### Getting the three most overlay reviews for a dealer

To get the three most overlay reviews just execute following command:

```shell
$ mix overly_positive --dealer "McKaig Chevrolet Buick"
```

### Running tests

To run tests you can run:

```shell
$ mix test
```

## Building documentation

To build documentation run the following command:

```shell
$ mix docs
```

## Contribute

Fork the repo and make your changes.

After your changes are done, please remember to run `mix format` to guarantee all files are properly formatted and then run the full suite with `mix test`.

With tests running and passing, you are ready to contribute to DealerScraper and send a pull request.

Or, feel free to file an issue and start a discussion about the new feature you have in mind.

## License

DealerScraper source code is released under MIT License.
Check the [LICENSE](LICENSE) for more information.