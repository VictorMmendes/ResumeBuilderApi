class CreateExperiencePositions < ActiveRecord::Migration[8.1]
  def change
    create_table :experience_positions do |t|
      t.references :experience_group, null: false, foreign_key: true
      t.string :title, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.boolean :current, null: false, default: false
      t.text :summary
      t.integer :display_order, null: false

      t.timestamps
    end

    add_index :experience_positions, [ :experience_group_id, :display_order ], unique: true
  end
end
