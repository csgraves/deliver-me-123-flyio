class Delivery < ApplicationRecord
  belongs_to :schedule

  #validate :check_user_availability

  #geocoded_by :dest_address, latitude: :dest_lat, longitude: :dest_lon
  #geocoded_by :origin_address, latitude: :origin_lat, longitude: :origin_lon

  #after_validation :geocode_dest_address, if: :will_save_change_to_dest_address?
  #after_validation :geocode_origin_address, if: :will_save_change_to_origin_address?

    private
    
    def check_user_availability
        if schedule.user.present? && !schedule.user.availabilities_available?(self)
            errors.add(:base, "User is not available during the delivery schedule")
        end
    end
end
