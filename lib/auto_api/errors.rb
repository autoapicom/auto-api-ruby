# frozen_string_literal: true

module AutoApi
  # Base exception for all auto-api.com API errors.
  class ApiError < StandardError
    # @return [Integer] HTTP status code returned by the API
    attr_reader :status_code

    # @return [String, nil] raw response body from the API
    attr_reader :response_body

    # @param status_code [Integer] HTTP status code
    # @param message [String] error message
    # @param response_body [String, nil] raw response body
    def initialize(status_code, message, response_body = nil)
      @status_code = status_code
      @response_body = response_body
      super("API error #{status_code}: #{message}")
    end
  end

  # Exception for authentication errors (HTTP 401/403).
  class AuthError < ApiError
    # @param status_code [Integer] HTTP status code (401 or 403)
    # @param message [String] error message
    # @param response_body [String, nil] raw response body
    def initialize(status_code, message, response_body = nil)
      @status_code = status_code
      @response_body = response_body
      super(status_code, message, response_body)
    end
  end
end
