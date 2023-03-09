class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_id
      t.integer :account_id
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
    add_index :users, :user_id
    add_index :users, :account_id
  end
end
