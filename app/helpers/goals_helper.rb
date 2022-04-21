module GoalsHelper
  def akc_price
    AlphaCoin.first.price
  end

  def format_date(num_days)
    (Time.now + num_days.days).strftime('%m/%d/%Y')
  end

  def convert_to_usd(coin)
    coin * akc_price
  end
end