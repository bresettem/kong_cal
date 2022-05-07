class TribeItem < ApplicationRecord
  belongs_to :user
  validates :owned, presence: true, numericality: { greater_than_or_equal_to: 0 }
end