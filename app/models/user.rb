class User < ApplicationRecord

	# Account
	belongs_to :account, :inverse_of => :users
	accepts_nested_attributes_for :account

	# Trainers
	has_many :trainers, dependent: :destroy, :inverse_of => :user
	accepts_nested_attributes_for :trainers

	has_many :schedules, dependent: :destroy, :inverse_of => :user
	accepts_nested_attributes_for :schedules

	# Clients
	has_many :clients, dependent: :destroy, :inverse_of => :user
	accepts_nested_attributes_for :clients
 
	# Lessons
	has_many :bookings, dependent: :destroy, :inverse_of => :user
	accepts_nested_attributes_for :bookings
 
	has_many :lesson_payments, dependent: :destroy, :inverse_of => :user
	accepts_nested_attributes_for :lesson_payments

end
