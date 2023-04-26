class ApplicationController < ActionController::Base


	def index 
		#
	end

	def after_sign_in_path_for(resource)
		user_dashboard_path
	end
end
