module TribeItemsHelper
  def convert_to_usd(tribe_price, akc_price)
    tribe_price * akc_price
  end

  def sum_daily_yield(daily_yield, owned)
    daily_yield * owned
  end
end