# auto-api-client-ruby

[![Gem Version](https://badge.fury.io/rb/auto-api-client.svg)](https://rubygems.org/gems/auto-api-client)
[![Ruby](https://img.shields.io/badge/Ruby-2.5%2B-red)](https://ruby-lang.org)
[![License](https://img.shields.io/github/license/autoapicom/auto-api-ruby)](LICENSE)

Ruby gem for the [auto-api.com](https://auto-api.com) car listings API — 8 marketplaces, one client.

encar, mobile.de, autoscout24, che168, dongchedi, guazi, dubicars, dubizzle. No dependencies beyond stdlib (`net/http` + `json`).

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
info = client.get_offer_by_url("https://encar.com/dc/dc_cardetailview.do?carid=40427050")
```

### Decode offer data

The `data` hash structure depends on the source — each marketplace has its own set of fields:

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
| `encar` | [encar.com](https://encar.com) | South Korea |
| `mobilede` | [mobile.de](https://mobile.de) | Germany |
| `autoscout24` | [autoscout24.com](https://autoscout24.com) | Europe |
| `che168` | [che168.com](https://che168.com) | China |
| `dongchedi` | [dongchedi.com](https://dongchedi.com) | China |
| `guazi` | [guazi.com](https://guazi.com) | China |
| `dubicars` | [dubicars.com](https://dubicars.com) | UAE |
| `dubizzle` | [dubizzle.com](https://dubizzle.com) | UAE |

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
