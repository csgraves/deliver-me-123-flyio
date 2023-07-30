class Delivery < ApplicationRecord
  belongs_to :schedule

  validates :origin_leave, :dest_arrive, :dest_leave, presence: true
  validate :time_check
  validate :check_user_availability


  #geocoded_by :dest_address, latitude: :dest_lat, longitude: :dest_lon
  #geocoded_by :origin_address, latitude: :origin_lat, longitude: :origin_lon

  #after_validation :geocode_dest_address, if: :will_save_change_to_dest_address?
  #after_validation :geocode_origin_address, if: :will_save_change_to_origin_address?

    private

    def time_check
        return unless dest_arrive && dest_leave # Skip validation if either value is not present

        dest_arrive_seconds = dest_arrive.to_i
        #puts "Origin Leave: #{origin_leave_seconds} seconds"

        dest_leave_seconds = dest_leave.to_i
        #puts "Dest Leave: #{dest_leave_seconds} seconds"

        if dest_leave_seconds < dest_arrive_seconds
            #puts "Leaving destination before leaving origin"
            errors.add(:dest_leave, "must be greater than or equal to origin_leave")
        end


    end
    
    def check_user_availability
        if schedule.user.present? && !schedule.user.availabilities_available?(self)
            errors.add(:base, "User is not available during the delivery schedule")
        end
    end
end