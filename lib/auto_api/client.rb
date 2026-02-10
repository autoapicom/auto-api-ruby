# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module AutoApi
  # Client for the auto-api.com car listings API.
  class Client
    # Creates a new API client.
    #
    # @param api_key [String] API key from auto-api.com
    # @param api_version [String] API version (default: "v2")
    # @param base_url [String] base URL override (default: "https://auto-api.com")
    def initialize(api_key, api_version: "v2", base_url: "https://auto-api.com")
      @api_key = api_key
      @api_version = api_version
      @base_url = base_url.chomp("/")
    end

    # Returns available filters for a source (brands, models, body types, etc.)
    #
    # @param source [String] source platform name
    # @return [Hash] available filters
    def get_filters(source)
      get("api/#{@api_version}/#{source}/filters")
    end

    # Returns a paginated list of offers with optional filters.
    #
    # @param source [String] source platform name
    # @param page [Integer] page number (required)
    # @param brand [String, nil] filter by brand
    # @param model [String, nil] filter by model
    # @param configuration [String, nil] filter by configuration
    # @param complectation [String, nil] filter by complectation
    # @param transmission [String, nil] filter by transmission
    # @param color [String, nil] filter by color
    # @param body_type [String, nil] filter by body type
    # @param engine_type [String, nil] filter by engine type
    # @param year_from [Integer, nil] minimum year
    # @param year_to [Integer, nil] maximum year
    # @param mileage_from [Integer, nil] minimum mileage
    # @param mileage_to [Integer, nil] maximum mileage
    # @param price_from [Integer, nil] minimum price
    # @param price_to [Integer, nil] maximum price
    # @return [Hash] { "result" => [...], "meta" => { "page" => ..., "next_page" => ... } }
    def get_offers(source, page:, brand: nil, model: nil, configuration: nil,
                   complectation: nil, transmission: nil, color: nil,
                   body_type: nil, engine_type: nil,
                   year_from: nil, year_to: nil,
                   mileage_from: nil, mileage_to: nil,
                   price_from: nil, price_to: nil)
      params = { page: page }
      params[:brand] = brand if brand
      params[:model] = model if model
      params[:configuration] = configuration if configuration
      params[:complectation] = complectation if complectation
      params[:transmission] = transmission if transmission
      params[:color] = color if color
      params[:body_type] = body_type if body_type
      params[:engine_type] = engine_type if engine_type
      params[:year_from] = year_from if year_from
      params[:year_to] = year_to if year_to
      params[:mileage_from] = mileage_from if mileage_from
      params[:mileage_to] = mileage_to if mileage_to
      params[:price_from] = price_from if price_from
      params[:price_to] = price_to if price_to

      get("api/#{@api_version}/#{source}/offers", params)
    end

    # Returns a single offer by inner_id.
    #
    # @param source [String] source platform name
    # @param inner_id [String] offer inner ID
    # @return [Hash] offer data
    def get_offer(source, inner_id)
      get("api/#{@api_version}/#{source}/offer", { inner_id: inner_id })
    end

    # Returns a change_id for the given date.
    #
    # @param source [String] source platform name
    # @param date [String] date in yyyy-mm-dd format
    # @return [Integer] change_id for the given date
    def get_change_id(source, date)
      result = get("api/#{@api_version}/#{source}/change_id", { date: date })
      result["change_id"]
    end

    # Returns a changes feed (added/changed/removed) starting from change_id.
    #
    # @param source [String] source platform name
    # @param change_id [Integer] change ID to start from
    # @return [Hash] { "result" => [...], "meta" => { "cur_change_id" => ..., "next_change_id" => ... } }
    def get_changes(source, change_id)
      get("api/#{@api_version}/#{source}/changes", { change_id: change_id })
    end

    # Returns offer data by its URL on the marketplace.
    # Uses POST /api/v1/offer/info with x-api-key header.
    #
    # @param url [String] marketplace offer URL
    # @return [Hash] offer data
    def get_offer_by_url(url)
      post("api/v1/offer/info", { url: url })
    end

    private

    def get(endpoint, params = {})
      params[:api_key] = @api_key

      uri = URI("#{@base_url}/#{endpoint}")
      uri.query = URI.encode_www_form(params)

      request = Net::HTTP::Get.new(uri)
      execute(uri, request)
    end

    def post(endpoint, data)
      uri = URI("#{@base_url}/#{endpoint}")

      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["x-api-key"] = @api_key
      request.body = JSON.generate(data)

      execute(uri, request)
    end

    def execute(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = 30
      http.read_timeout = 30

      response = http.request(request)
      handle_response(response)
    end

    def handle_response(response)
      body = response.body
      status_code = response.code.to_i

      unless (200...300).include?(status_code)
        message = "API error: #{status_code}"

        begin
          parsed = JSON.parse(body)
          message = parsed["message"] if parsed.is_a?(Hash) && parsed["message"]
        rescue JSON::ParserError
          # Use default message if response is not valid JSON
        end

        if status_code == 401 || status_code == 403
          raise AuthError.new(status_code, message, body)
        end

        raise ApiError.new(status_code, message, body)
      end

      begin
        JSON.parse(body)
      rescue JSON::ParserError
        raise ApiError.new(status_code, "Invalid JSON response: #{body[0, 200]}", body)
      end
    end
  end
end
