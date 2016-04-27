# Glosbe

Crystal client for [Glosbe API](https://glosbe.com/a-api)

[![Build Status](https://travis-ci.org/greyblake/crystal-glosbe.svg?branch=master)](https://travis-ci.org/greyblake/crystal-glosbe)

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  glosbe:
    github: greyblake/crystal-glosbe
```

## Usage

```crystal
require "glosbe"

client = Glosbe::Client.new

# Translate a word from German to English
response = client.translate("de", "en", "Achtung", tm: true)  # =>  #<Glosbe::TranslateResponse ... >

# Print translations
response.tuc.each do |translation|
  puts translation.phrase.try(&.text)
end

# Print examples of usage
response.examples.each do |example|
  puts example.first    # sentence in German
  puts example.second   # translation in English
end
```

Please check [Glosbe::Client](https://github.com/greyblake/crystal-glosbe/blob/master/src/glosbe/client.cr)
and [Glosbe API](https://glosbe.com/a-api) for more details.

### Errors

Client methods may raise the following errors:

* Glosbe::Error
 * Glosbe::HttpError
 * Glosbe::ParseError

## Running tests

```
crystal spec
```

## Contributors

- [greyblake](https://github.com/greyblake) Sergey Potapov - creator, maintainer
