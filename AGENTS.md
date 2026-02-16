# auto-api Ruby Client

Ruby client for [auto-api.com](https://auto-api.com) — car listings API across 8 marketplaces.

## Quick Start

```bash
gem install auto-api-client
```

```ruby
require "auto_api"

client = AutoApi::Client.new("your-api-key", "https://api1.auto-api.com")
offers = client.get_offers("encar", page: 1)
```

## Build & Test

```bash
bundle install
gem build auto-api-client.gemspec
ruby examples/example.rb
```

## Key Files

- `lib/auto_api.rb` — Main require file, loads client and errors
- `lib/auto_api/client.rb` — Client class, 6 methods, HTTP helpers
- `lib/auto_api/errors.rb` — ApiError and AuthError
- `lib/auto_api/version.rb` — VERSION constant
- `auto-api-client.gemspec` — Gem specification
- `Gemfile` — Development dependencies

## Conventions

- Ruby 2.5+, zero dependencies (net/http, json, uri from stdlib)
- snake_case for everything — Ruby convention
- Hash params for optional parameters: `get_offers("encar", page: 1, brand: "BMW")`
- Returns parsed Hashes — Ruby convention, like PHP arrays and Python dicts
- StandardError subclass — Ruby exception convention
- attr_reader for exception properties
- Module namespace AutoApi::Client
- require "auto_api" — gem name uses dashes, require uses underscores
- YARD documentation (@param, @return) on every public method, in English
- frozen_string_literal: true in every file

## API Methods

| Method | Params | Returns |
|--------|--------|---------|
| `get_filters(source)` | source name | `Hash` |
| `get_offers(source, params = {})` | source + hash params | `Hash` |
| `get_offer(source, inner_id)` | source + inner_id | `Hash` |
| `get_change_id(source, date)` | source + yyyy-mm-dd | `Integer` |
| `get_changes(source, change_id)` | source + change_id | `Hash` |
| `get_offer_by_url(url)` | marketplace URL | `Hash` |
