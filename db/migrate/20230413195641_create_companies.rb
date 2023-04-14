class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false

      t.string :company_iden, null: false
      t.bigint :company_id, nullL false

      t.timestamps
    end
  end
end
