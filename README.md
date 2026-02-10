# auto-api-client-ruby

[![Gem Version](https://badge.fury.io/rb/auto-api-client.svg)](https://rubygems.org/gems/auto-api-client)
[![Ruby](https://img.shields.io/badge/Ruby-2.5%2B-red)](https://www.ruby-lang.org)
[![License](https://img.shields.io/github/license/autoapicom/auto-api-ruby)](LICENSE)

Ruby client for [auto-api.com](https://auto-api.com) — car listings API across multiple marketplaces.

One API to access car listings from 8 marketplaces: encar, mobile.de, autoscout24, che168, dongchedi, guazi, dubicars, dubizzle. Search offers, track price changes, and get listing data in a unified format.

## Installation

```bash
gem install auto-api-client
```

Or add to your Gemfile:

```ruby
gem "auto-api-client"
```

## Usage

```ruby
require "auto_api"

client = AutoApi::Client.new("your-api-key")
```

### Get filters

```ruby
filters = client.get_filters("encar")
```

### Search offers

```ruby
offers = client.get_offers("mobilede", page: 1, brand: "BMW", year_from: 2020)

# Pagination
puts offers["meta"]["page"]
puts offers["meta"]["next_page"]
```

### Get single offer

```ruby
offer = client.get_offer("encar", "40427050")
```

### Track changes

```ruby
change_id = client.get_change_id("encar", "2025-01-15")
changes = client.get_changes("encar", change_id)

# Next batch
next_batch = client.get_changes("encar", changes["meta"]["next_change_id"])
```

### Get offer by URL

```ruby
info = client.get_offer_by_url("https://www.encar.com/dc/dc_cardetailview.do?carid=40427050")
```

### Decode offer data

Offer data varies between sources and is returned as a Hash:

```ruby
offers["result"].each do |item|
  data = item["data"]
  puts "#{data['mark']} #{data['model']} #{data['year']} — $#{data['price']}"
end
```

### Error handling

```ruby
begin
  offers = client.get_offers("encar", page: 1)
rescue AutoApi::AuthError => e
  # 401/403 — invalid API key
  puts "#{e.status_code}: #{e.message}"
rescue AutoApi::ApiError => e
  # Any other API error
  puts "#{e.status_code}: #{e.message}"
  puts e.response_body
end
```

## Supported sources

| Source | Platform | Region |
|--------|----------|--------|
| `encar` | [encar.com](https://www.encar.com) | South Korea |
| `mobilede` | [mobile.de](https://www.mobile.de) | Germany |
| `autoscout24` | [autoscout24.com](https://www.autoscout24.com) | Europe |
| `che168` | [che168.com](https://www.che168.com) | China |
| `dongchedi` | [dongchedi.com](https://www.dongchedi.com) | China |
| `guazi` | [guazi.com](https://www.guazi.com) | China |
| `dubicars` | [dubicars.com](https://www.dubicars.com) | UAE |
| `dubizzle` | [dubizzle.com](https://www.dubizzle.com) | UAE |

## Other languages

| Language | Package |
|----------|---------|
| PHP | [auto-api/client](https://github.com/autoapicom/auto-api-php) |
| TypeScript | [@auto-api/client](https://github.com/autoapicom/auto-api-node) |
| Python | [auto-api-client](https://github.com/autoapicom/auto-api-python) |
| Go | [auto-api-go](https://github.com/autoapicom/auto-api-go) |
| C# | [AutoApi.Client](https://github.com/autoapicom/auto-api-dotnet) |
| Java | [auto-api-client](https://github.com/autoapicom/auto-api-java) |
| Rust | [auto-api-client](https://github.com/autoapicom/auto-api-rust) |

## Documentation

[auto-api.com](https://auto-api.com)
