class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :branch, optional: true
  has_many :availabilities, dependent: :destroy
  has_one :schedule, dependent: :destroy

  after_create :create_default_schedule

  has_one :company, through: :branch

  has_many :deliveries, through: :schedule

  #before_validation :set_default_role, on: :create

  #private

  #def set_default_role
    #self.role ||= :admin
  #end

  def availabilities_available?(delivery)
    # Implement your logic to check if the user's availabilities are available
    # For example, you might check if there are any availabilities within the delivery schedule
    availabilities.where('start_time <= ? AND end_time >= ?', delivery.origin_leave, delivery.dest_leave).exists?
  end

  private 

  def create_default_schedule
    create_schedule(user_id: id, user_only: true) # Create a new schedule associated with the user
  end
end
