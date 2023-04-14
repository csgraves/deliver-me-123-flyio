class User < ApplicationRecord
  belongs_to :branch

  has_many :availabilites
  has_many :deliveries

  after_initialize :set_default_role, :if => :new_record?

end
