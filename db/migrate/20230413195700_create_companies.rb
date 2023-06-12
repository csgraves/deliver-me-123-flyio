class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_iden
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
