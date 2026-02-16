# frozen_string_literal: true

require_relative "test_helper"

class TestApiError < Minitest::Test
  def test_extends_standard_error
    error = AutoApi::ApiError.new(500, "Error")
    assert_kind_of StandardError, error
  end

  def test_status_code
    error = AutoApi::ApiError.new(422, "Error")
    assert_equal 422, error.status_code
  end

  def test_message
    error = AutoApi::ApiError.new(500, "Something went wrong")
    assert_includes error.message, "Something went wrong"
  end

  def test_response_body_when_provided
    error = AutoApi::ApiError.new(422, "Error", '{"errors":["invalid"]}')
    assert_equal '{"errors":["invalid"]}', error.response_body
  end

  def test_response_body_nil_by_default
    error = AutoApi::ApiError.new(500, "Error")
    assert_nil error.response_body
  end
end

class TestAuthError < Minitest::Test
  def test_extends_api_error
    error = AutoApi::AuthError.new(401, "Unauthorized")
    assert_kind_of AutoApi::ApiError, error
  end

  def test_extends_standard_error
    error = AutoApi::AuthError.new(401, "Unauthorized")
    assert_kind_of StandardError, error
  end

  def test_status_code
    error = AutoApi::AuthError.new(403, "Forbidden")
    assert_equal 403, error.status_code
  end

  def test_message
    error = AutoApi::AuthError.new(401, "Access denied")
    assert_includes error.message, "Access denied"
  end

  def test_response_body
    error = AutoApi::AuthError.new(401, "Bad key", '{"message":"bad"}')
    assert_equal '{"message":"bad"}', error.response_body
  end
end
