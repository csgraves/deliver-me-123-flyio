class CompanyOpeningHour < ApplicationRecord
  belongs_to :company

  enum day_of_week: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  validates :day_of_week, :open_time, :close_time, presence: true
  validate :validate_open_time_before_close_time

  def validate_open_time_before_close_time
      return unless open_time && close_time

      if open_time >= close_time
        errors.add(:base, "Open time must be before close time for #{day_of_week}")
      end
  end
end