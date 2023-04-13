class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :day_of_week
      t.references :branch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
