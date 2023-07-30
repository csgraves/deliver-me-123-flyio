class ApplicationController < ActionController::Base
	helper_method :joined_company

	  private

	  def joined_company
		current_user && current_user.branch_id.present?
	  end

	def index 
		#
	end

	def after_sign_in_path_for(resource)
		user_dashboard_path
	end
end
