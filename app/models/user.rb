class User < ApplicationRecord
belongs_to :branch
has_many :availabilities, dependent: :destroy
has_many :deliveries, dependent: :destroy

end
