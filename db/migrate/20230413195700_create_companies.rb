class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies, id: :bigint, unsigned: true, force: :cascade do |t|
      t.string :name
      t.string :company_iden
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_column :companies, :company_id, :serial, null: false, first: true
    add_index :companies, :company_id, unique: true
  end
end
