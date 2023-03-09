class User < ApplicationRecord

	belongs_to :account, :inverse_of => :user
	accepts_nested_attributes_for :account

end
