class Delivery < ApplicationRecord
  belongs_to :driver
  belongs_to :branch
end
