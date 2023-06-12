class RenameDeliveryColumns < ActiveRecord::Migration[7.0]
  def change
	rename_column :deliveries, :deliver, :dest_arrive
	rename_column :deliveries, :leave, :dest_leave
	rename_column :deliveries, :start, :origin_leave
	rename_column :deliveries, :deliver_lat, :dest_lat
	rename_column :deliveries, :deliver_lon, :dest_lon
	rename_column :deliveries, :start_lat, :origin_lat
	rename_column :deliveries, :start_lon, :origin_lon
  end
end
