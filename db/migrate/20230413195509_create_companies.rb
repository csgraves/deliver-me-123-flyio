class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_iden
      t.bigint :company_id, null: false #Needed for relation to branches

      t.timestamps
    end
  end
end
