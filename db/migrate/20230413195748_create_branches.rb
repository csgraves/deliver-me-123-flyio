class CreateBranches < ActiveRecord::Migration[7.0]
  def change
    create_table :branches do |t|
      t.string :name, null: false
      t.string :branch_iden, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
