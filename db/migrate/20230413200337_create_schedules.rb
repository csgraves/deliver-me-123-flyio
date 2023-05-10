class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :day_of_week
      t.references :branch, foreign_key: true #null :false
      t.references :user, foreign_key: true #null :false

      t.timestamps
    end
  end
end
