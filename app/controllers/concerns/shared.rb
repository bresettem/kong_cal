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
end