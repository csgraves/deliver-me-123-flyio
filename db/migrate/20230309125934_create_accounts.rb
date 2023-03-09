class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.integer :accound_id
      t.string :company

      t.timestamps
    end
    add_index :accounts, :accound_id
  end
end
