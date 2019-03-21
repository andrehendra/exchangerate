class Exchange < ApplicationRecord
  validates :date, presence: true
  validates :from, presence: true
  validates :to, presence: true
end
