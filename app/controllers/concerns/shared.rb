module Shared
  require 'net/http'
  extend ActiveSupport::Concern

  def get_sum
    owned = get_owned
    puts "owned: #{owned.empty?}"
    return 0 if owned.empty?
    sum = 0
    owned.each do |o|
      o.owned.times do
        sum += o.daily_yield
      end
    end
    return 0 if sum === 0
    puts "sum: #{sum}"
    find_claim = @user.claim
    user_claim = if find_claim.empty?
                   0
                 else
                   @user.claim.last
                 end
    claimed = to_days(user_claim)
    calculate_bonus_split(sum, claimed)
  end

  def get_sum_goal(goal)
    owned = get_owned
    return 0 if owned.empty?
    sum = 0
    owned.each do |o|
      o.owned.times do
        sum += o.daily_yield
      end
    end
    puts "sum: #{sum}"
    calculate_bonus_goal(sum, goal)
  end

  def get_split_daily_yield
    owned = get_owned
    return 0 if owned.empty?

    split = []
    owned.each do |o|
      sum = 0
      o.owned.times do
        sum += o.daily_yield
      end
      split << {
        owned: o.item,
        sum: sum
      }
    end
    split
  end

  def get_akc_price
    AlphaCoin.first.price
  end

  def get_owned
    @user.tribe_items.where("owned >= ?", 1)
  end

  def calculate_bonus_goal(daily_yield, index)
    daily_yield + (daily_yield * get_bonus(index))
  end

  def to_days(last_claimed)
    return 0 if last_claimed === 0
    (Date.today - last_claimed.claimed).to_i
  end

  def calculate_bonus_split(daily_yield, index)
    bonus = get_bonus(index)
    combined = daily_yield + (daily_yield * bonus)
    [combined, "#{(bonus * 100).round(0)}%", daily_yield]
  end

  def update_shared_alpha_coin
    source = 'https://api.coinpaprika.com/v1/tickers/akc-alpha-coins'
    resp = Net::HTTP.get_response(URI.parse(source))
    data = resp.body
    result = JSON.parse(data)
    AlphaCoin.upsert({
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
                       percent_from_price_ath: result['quotes']['USD']['percent_from_price_ath'],
                     }, unique_by: %i[ name symbol ]
    )
    puts "Updated AlphaCoin at #{Time.now}"
  end

  private

    def get_bonus(index)
      case index
        when 0..2
          0
        when 3..6
          0.02
        when 5..13
          0.05
        when 14..29
          0.12
        when 30..59
          0.25
        when 60..89
          0.40
        else
          0.50
      end
    end
end