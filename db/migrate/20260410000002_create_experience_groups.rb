class CreateExperienceGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :experience_groups do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :company_name, null: false
      t.string :location
      t.integer :display_order, null: false

      t.timestamps
    end

    add_index :experience_groups, [ :resume_id, :display_order ], unique: true
  end
end
