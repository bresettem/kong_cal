# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'net/http'
source = 'https://api.coinpaprika.com/v1/tickers/akc-alpha-coins'
resp = Net::HTTP.get_response(URI.parse(source))
data = resp.body
result = JSON.parse(data)
AlphaCoin.create(
  name: result['name'],
  symbol: result['symbol'],
  last_updated: result['last_updated'],
  price: result['quotes']['USD']['price'],
  volume_24h: result['quotes']['USD']['volume_24h'],
  volume_24h_change_24h: result['quotes']['USD']['volume_24h_change_24h'],
  market_cap: result['quotes']['USD']['market_cap'],
  percent_change_15m: result['quotes']['USD']['percent_change_15m'],
  percent_change_30m: result['quotes']['USD']['percent_change_30m'],
  percent_change_1h: result['quotes']['USD']['percent_change_1h'],
  percent_change_6h: result['quotes']['USD']['percent_change_6h'],
  percent_change_12h: result['quotes']['USD']['percent_change_12h'],
  percent_change_24h: result['quotes']['USD']['percent_change_24h'],
  percent_change_7d: result['quotes']['USD']['percent_change_7d'],
  percent_change_30d: result['quotes']['USD']['percent_change_30d'],
  percent_change_1y: result['quotes']['USD']['percent_change_1y'],
  ath_price: result['quotes']['USD']['ath_price'],
  ath_date: result['quotes']['USD']['ath_date'],
  percent_from_price_ath: result['quotes']['USD']['percent_from_price_ath']
)
puts "Inserted into AlphaCoin"