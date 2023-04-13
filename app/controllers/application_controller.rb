class ApplicationController < ActionController::Base
	#before_action :set_time_zone #, if: :logged_in?
	#around_action :set_user, only: User
	#around_action :set_time_zone #, if: :User

	def index 

	end

	private
	def set_time_zone
		#Time.zone = User.time_zone #current_user.time_zone

		#Time.use_zone(User.time_zone) {yield}
		#Time.use_zone(User.find(params[:time_zone])) {yield}
		#@time_zone = User.find(params[:time_zone])
	end
	
end
