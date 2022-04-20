module Shared
  extend ActiveSupport::Concern

  def get_sum
    owned = get_owned
    raise "Owned is empty" if owned.nil?
    sum = 0
    owned.each do |o|
      o.owned.times do
        sum += o.daily_yield
      end
    end
    sum
  end

  def get_split_daily_yield
    owned = get_owned
    raise "Owned is empty" if owned.nil?
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
    TribeItem.where("owned >= ?", 1)
  end

  def calculate_bonus_goal(daily_yield, index)
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