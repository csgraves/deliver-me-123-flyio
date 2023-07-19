class Company < ApplicationRecord
has_many :branches, dependent: :destroy
has_many :company_opening_hours, dependent: :destroy
accepts_nested_attributes_for :company_opening_hours
validates_associated :company_opening_hours

has_many :users, through: :branches
has_many :availabilities, through: :users
has_many :schedules, through: :users
has_many :branch_schedules, through: :branches, source: :schedules


end
