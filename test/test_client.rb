# frozen_string_literal: true

require_relative "test_helper"
require "json"

class TestGetFilters < Minitest::Test
  def test_returns_parsed_response
    expected = { "brands" => %w[Toyota Honda], "body_types" => %w[sedan suv] }
    stub_request(:get, /encar\/filters/)
      .to_return(body: JSON.generate(expected), status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_filters("encar")

    assert_equal expected, result
  end

  def test_calls_correct_endpoint
    stub_request(:get, "#{BASE_URL}/api/v2/encar/filters?api_key=test-key")
      .to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_filters("encar")

    assert_requested :get, /api\/v2\/encar\/filters/
  end

  def test_includes_api_key_in_query
    stub_request(:get, /filters/).to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("my-secret-key")
    client.get_filters("encar")

    assert_requested :get, /api_key=my-secret-key/
  end

  def test_different_source
    stub_request(:get, /mobile_de\/filters/).to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_filters("mobile_de")

    assert_requested :get, /mobile_de\/filters/
  end
end

class TestGetOffers < Minitest::Test
  def test_returns_offers_data
    expected = { "data" => [{ "id" => 1 }], "total" => 100 }
    stub_request(:get, /encar\/offers/).to_return(body: JSON.generate(expected), status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_offers("encar", page: 1)

    assert_equal expected, result
  end

  def test_passes_page_parameter
    stub_request(:get, /offers/).to_return(body: '{"data":[]}', status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offers("encar", page: 1)

    assert_requested :get, /page=1/
  end

  def test_passes_multiple_filters
    stub_request(:get, /offers/).to_return(body: '{"data":[]}', status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offers("mobile_de", page: 2, brand: "BMW", year_from: 2020)

    assert_requested :get, /brand=BMW/
    assert_requested :get, /year_from=2020/
    assert_requested :get, /page=2/
  end

  def test_works_without_params
    stub_request(:get, /encar\/offers/).to_return(body: '{"data":[]}', status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offers("encar")

    assert_requested :get, /encar\/offers/
  end
end

class TestGetOffer < Minitest::Test
  def test_returns_single_offer
    expected = { "inner_id" => "abc123", "brand" => "Toyota" }
    stub_request(:get, /encar\/offer/).to_return(body: JSON.generate(expected), status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_offer("encar", "abc123")

    assert_equal expected, result
  end

  def test_passes_inner_id
    stub_request(:get, /offer/).to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offer("encar", "abc123")

    assert_requested :get, /inner_id=abc123/
  end
end

class TestGetChangeId < Minitest::Test
  def test_returns_integer
    stub_request(:get, /change_id/).to_return(body: '{"change_id":42567}', status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_change_id("encar", "2024-01-15")

    assert_equal 42567, result
  end

  def test_passes_date_parameter
    stub_request(:get, /change_id/).to_return(body: '{"change_id":0}', status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_change_id("encar", "2024-01-15")

    assert_requested :get, /date=2024-01-15/
  end

  def test_returns_zero
    stub_request(:get, /change_id/).to_return(body: '{"change_id":0}', status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_change_id("encar", "2024-01-01")

    assert_equal 0, result
  end
end

class TestGetChanges < Minitest::Test
  def test_returns_changes_feed
    expected = { "added" => [{ "id" => "new1" }], "changed" => [], "removed" => [] }
    stub_request(:get, /changes/).to_return(body: JSON.generate(expected), status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_changes("encar", 42567)

    assert_equal expected, result
  end

  def test_passes_change_id
    stub_request(:get, /changes/).to_return(body: '{"added":[]}', status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_changes("encar", 42567)

    assert_requested :get, /change_id=42567/
  end
end

class TestGetOfferByUrl < Minitest::Test
  def test_returns_offer_data
    expected = { "brand" => "BMW", "model" => "X5", "price" => 45000 }
    stub_request(:post, /offer\/info/).to_return(body: JSON.generate(expected), status: 200)

    client = AutoApi::Client.new("test-key")
    result = client.get_offer_by_url("https://www.encar.com/car/123")

    assert_equal expected, result
  end

  def test_uses_post_method
    stub_request(:post, /offer\/info/).to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offer_by_url("https://example.com/car/123")

    assert_requested :post, /offer\/info/
  end

  def test_uses_v1_endpoint
    stub_request(:post, "#{BASE_URL}/api/v1/offer/info")
      .to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offer_by_url("https://example.com/car/123")

    assert_requested :post, /api\/v1\/offer\/info/
  end

  def test_sends_api_key_in_header
    stub_request(:post, /offer\/info/)
      .with(headers: { "x-api-key" => "header-key" })
      .to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("header-key")
    client.get_offer_by_url("https://example.com/car/123")

    assert_requested :post, /offer\/info/, headers: { "x-api-key" => "header-key" }
  end

  def test_sends_url_in_body
    stub_request(:post, /offer\/info/)
      .with(body: { url: "https://example.com/car/123" }.to_json)
      .to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offer_by_url("https://example.com/car/123")

    assert_requested :post, /offer\/info/,
                     body: { url: "https://example.com/car/123" }.to_json
  end

  def test_sends_content_type_json
    stub_request(:post, /offer\/info/)
      .with(headers: { "Content-Type" => "application/json" })
      .to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key")
    client.get_offer_by_url("https://example.com/car/123")

    assert_requested :post, /offer\/info/, headers: { "Content-Type" => "application/json" }
  end
end

class TestCustomApiVersion < Minitest::Test
  def test_uses_custom_version
    stub_request(:get, /api\/v3\/encar\/filters/).to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key", "https://api1.auto-api.com", api_version: "v3")
    client.get_filters("encar")

    assert_requested :get, /api\/v3\/encar\/filters/
  end
end

class TestCustomBaseUrl < Minitest::Test
  def test_uses_custom_base_url
    stub_request(:get, /custom\.api\.com/).to_return(body: "{}", status: 200)

    client = AutoApi::Client.new("test-key", "https://custom.api.com")
    client.get_filters("encar")

    assert_requested :get, /custom\.api\.com/
  end
end

class TestErrorHandling < Minitest::Test
  def test_raises_api_error_on_server_error
    stub_request(:get, /filters/)
      .to_return(body: '{"message":"Internal server error"}', status: 500)

    client = AutoApi::Client.new("test-key")

    assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
  end

  def test_api_error_contains_status_code
    stub_request(:get, /filters/)
      .to_return(body: '{"message":"Server error"}', status: 500)

    client = AutoApi::Client.new("test-key")

    error = assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
    assert_equal 500, error.status_code
  end

  def test_api_error_contains_response_body
    body = '{"message":"Validation failed","errors":["invalid page"]}'
    stub_request(:get, /filters/).to_return(body: body, status: 422)

    client = AutoApi::Client.new("test-key")

    error = assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
    assert_equal body, error.response_body
  end

  def test_uses_message_from_response_body
    stub_request(:get, /filters/)
      .to_return(body: '{"message":"Custom error"}', status: 500)

    client = AutoApi::Client.new("test-key")

    error = assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
    assert_includes error.message, "Custom error"
  end

  def test_fallback_message_when_no_message_field
    stub_request(:get, /filters/)
      .to_return(body: '{"error":"something"}', status: 500)

    client = AutoApi::Client.new("test-key")

    error = assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
    assert_includes error.message, "API error"
    assert_includes error.message, "500"
  end

  def test_raises_auth_error_on_401
    stub_request(:get, /filters/)
      .to_return(body: '{"message":"Unauthorized"}', status: 401)

    client = AutoApi::Client.new("test-key")

    assert_raises(AutoApi::AuthError) { client.get_filters("encar") }
  end

  def test_raises_auth_error_on_403
    stub_request(:get, /offers/)
      .to_return(body: '{"message":"Forbidden"}', status: 403)

    client = AutoApi::Client.new("test-key")

    assert_raises(AutoApi::AuthError) { client.get_offers("encar") }
  end

  def test_auth_error_is_also_api_error
    stub_request(:get, /filters/)
      .to_return(body: '{"message":"Bad key"}', status: 401)

    client = AutoApi::Client.new("test-key")

    assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
  end

  def test_raises_api_error_on_invalid_json
    stub_request(:get, /filters/).to_return(body: "not json at all", status: 200)

    client = AutoApi::Client.new("test-key")

    error = assert_raises(AutoApi::ApiError) { client.get_filters("encar") }
    assert_includes error.message, "Invalid JSON response"
  end

  def test_404_raises_api_error_not_auth_error
    stub_request(:get, /filters/)
      .to_return(body: '{"message":"Source not found"}', status: 404)

    client = AutoApi::Client.new("test-key")

    error = assert_raises(AutoApi::ApiError) { client.get_filters("unknown_source") }
    assert_equal 404, error.status_code
    refute_kind_of AutoApi::AuthError, error
  end
end
