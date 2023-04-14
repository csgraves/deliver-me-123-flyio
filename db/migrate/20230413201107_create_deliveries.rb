class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.datetime :deliver
      t.datetime :leave
      t.references :user, null: false, foreign_key: true
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
