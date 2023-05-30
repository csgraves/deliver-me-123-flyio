class AddFieldsToDeliveries < ActiveRecord::Migration[7.0]
  def change
    add_column :deliveries, :deliver_lat, :decimal, precision: 10, scale: 6
    add_column :deliveries, :deliver_lon, :decimal, precision: 10, scale: 6
    add_column :deliveries, :start, :datetime
    add_column :deliveries, :start_lat, :decimal, precision: 10, scale: 6
    add_column :deliveries, :start_lon, :decimal, precision: 10, scale: 6
  end
end
