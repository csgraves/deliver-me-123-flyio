class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
belongs_to :branch, optional: true
has_many :availabilities, dependent: :destroy
has_many :deliveries, dependent: :destroy

end
