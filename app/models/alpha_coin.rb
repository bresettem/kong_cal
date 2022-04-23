class AlphaCoin < ApplicationRecord
  include Shared

  def self.update_alpha_coin
    update_shared_alpha_coin
  end
end