class Company < ApplicationRecord
has_many :branches, dependent: :destroy
has_many :company_opening_hours, dependent: :destroy
accepts_nested_attributes_for :company_opening_hours
validates_associated :company_opening_hours

end
