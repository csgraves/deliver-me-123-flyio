class Branch < ApplicationRecord
  belongs_to :company
  has_many :users, dependent: :destroy
  has_many :deliveries, dependent: :destroy
  has_many :schedules, dependent: :destroy

end
