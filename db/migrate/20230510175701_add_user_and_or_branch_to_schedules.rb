class AddUserAndOrBranchToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :user_only, :boolean
    add_column :schedules, :branch_only, :boolean
  end
end
