# GitHub Copilot Instructions — auto-api-ruby

Ruby client library for [auto-api.com](https://auto-api.com).

## Overview

- `AutoApi::Client` class with 6 public methods for interacting with the Auto API
- Zero external dependencies — uses only Ruby stdlib (net/http, json, uri)
- Keyword arguments for optional filters: `get_offers("encar", page: 1, brand: "BMW")`
- All methods return parsed Hashes — no wrapper or DTO classes
- Error handling via `ApiError` and `AuthError` (both inherit from `StandardError`)

## Guidelines

- All code comments and documentation must be in English
- Use `# frozen_string_literal: true` in every file
- Use snake_case for everything
- Use YARD-style documentation on public methods
- Never add gem dependencies — stdlib only
- Never create response wrapper classes
- Never use monkey patching
