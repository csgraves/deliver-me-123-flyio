class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :branch_iden
      t.string :company_iden
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end

    remove_index :branches, :company_id
    add_index :branches, :company_id
  end
end
