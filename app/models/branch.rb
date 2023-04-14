class Branch < ApplicationRecord
  belongs_to :company

  has_many :users
  has_many :schedules
  has_many :deliveries
end
