class AddDeliveryAddress < ActiveRecord::Migration[7.0]
  def change
	add_column :deliveries, :origin_address, :string
	add_column :deliveries, :dest_address, :string
  end
end
