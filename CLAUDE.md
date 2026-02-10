# Claude Instructions — auto-api-ruby

## Language

All code comments, documentation, and README files must be written in **English**.

## Commands

- Install dependencies: `bundle install`
- Run example: `ruby examples/example.rb`

## Key Files

- `lib/auto_api.rb` — entry point, requires all components
- `lib/auto_api/client.rb` — AutoApi::Client class (6 public methods)
- `lib/auto_api/errors.rb` — ApiError, AuthError (StandardError subclasses)
- `lib/auto_api/version.rb` — version constant
- `auto-api-client.gemspec` — gem specification

## Code Style

- Ruby 2.5+, zero external dependencies (net/http + json from stdlib)
- `# frozen_string_literal: true` in every file
- snake_case for methods, variables, file names
- Keyword arguments for optional filters: `get_offers("encar", page: 1, brand: "BMW")`
- All methods return parsed Hashes — no wrapper/DTO objects
- YARD documentation in English on all public methods
- Keep it simple — no unnecessary abstractions
