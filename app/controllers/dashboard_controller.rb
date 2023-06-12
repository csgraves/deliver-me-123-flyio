class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Add any code here to display data on the dashboard
    if current_user.branch_id.nil?
      @need_join_company = true
    end
  end


end
