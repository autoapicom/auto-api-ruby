# frozen_string_literal: true

require "minitest/autorun"
require "webmock/minitest"
require_relative "../lib/auto_api/errors"
require_relative "../lib/auto_api/client"

BASE_URL = "https://api1.auto-api.com"
