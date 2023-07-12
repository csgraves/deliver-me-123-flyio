class CreateCompanyOpeningHours < ActiveRecord::Migration[7.0]
  def change
    create_table :company_opening_hours do |t|
      t.references :company, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
