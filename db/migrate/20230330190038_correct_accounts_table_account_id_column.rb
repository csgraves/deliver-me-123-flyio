class CorrectAccountsTableAccountIdColumn < ActiveRecord::Migration[7.0]
  def change
	rename_column :accounts, :accound_id, :account_id
  end
end
