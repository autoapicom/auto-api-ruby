# Auto API Ruby Client — Complete usage example.
#
# Replace "your-api-key" with your actual API key from https://auto-api.com
#
# Run: ruby examples/example.rb

require_relative "../lib/auto_api"

client = AutoApi::Client.new("your-api-key")
source = "encar"

# --- Get available filters ---

filters = client.get_filters(source)
puts "Filter keys: #{filters.keys.size}"

# --- Search offers with filters ---

offers = client.get_offers(source, page: 1, brand: "Hyundai", year_from: 2020, price_to: 50000)

puts "\n--- Offers (page #{offers['meta']['page']}) ---"
offers["result"].each do |item|
  data = item["data"]
  puts "#{data['mark']} #{data['model']} #{data['year']} — $#{data['price']} (#{data['km_age']} km)"
end

# Pagination
if offers["meta"]["next_page"].to_i > 0
  next_page = client.get_offers(source, page: offers["meta"]["next_page"], brand: "Hyundai", year_from: 2020)
  puts "Next page has #{next_page['result'].size} offers"
end

# --- Get single offer ---

inner_id = "40427050"
inner_id = offers["result"].first["inner_id"] unless offers["result"].empty?

offer = client.get_offer(source, inner_id)
puts "\n--- Single offer ---"
unless offer["result"].empty?
  data = offer["result"].first["data"]
  puts "URL: #{data['url']}"
  puts "Seller: #{data['seller_type']}"
  puts "Images: #{data['images']&.size}"
end

# --- Track changes ---

change_id = client.get_change_id(source, "2025-01-15")
puts "\n--- Changes from 2025-01-15 (change_id: #{change_id}) ---"

changes = client.get_changes(source, change_id)
changes["result"].each do |change|
  puts "[#{change['change_type']}] #{change['inner_id']}"
end

if changes["meta"]["next_change_id"].to_i > 0
  more_changes = client.get_changes(source, changes["meta"]["next_change_id"])
  puts "Next batch: #{more_changes['result'].size} changes"
end

# --- Get offer by URL ---

info = client.get_offer_by_url("https://www.encar.com/dc/dc_cardetailview.do?carid=40427050")
puts "\n--- Offer by URL ---"
puts "#{info['mark']} #{info['model']} — $#{info['price']}"

# --- Error handling ---

bad_client = AutoApi::Client.new("invalid-key")
begin
  bad_client.get_offers("encar", page: 1)
rescue AutoApi::AuthError => e
  puts "\nAuth error: #{e.message} (HTTP #{e.status_code})"
rescue AutoApi::ApiError => e
  puts "\nAPI error: #{e.message} (HTTP #{e.status_code})"
  puts "Body: #{e.response_body}"
end
