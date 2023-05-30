class Delivery < ApplicationRecord
  belongs_to :schedule

  validate :check_user_availability

    private
    
    def check_user_availability
        if schedule.user.present? && !schedule.user.availabilities_available?(self)
            errors.add(:base, "User is not available during the delivery schedule")
        end
    end
end
