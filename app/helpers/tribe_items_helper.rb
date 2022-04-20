module TribeItemsHelper
  def convert_to_usd(tribe_price, akc_price)
    number_to_currency(tribe_price * akc_price)
  end

  def convert_to_usd_per_day(days, tribe_price, akc_price)
    day = days * tribe_price
    number_to_currency(day * akc_price)
  end

  def sum_daily_yield(daily_yield, owned)
    daily_yield * owned
  end

  def calculate_bonus(daily_yield, index)
    daily_yield + (daily_yield * get_bonus(index))
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