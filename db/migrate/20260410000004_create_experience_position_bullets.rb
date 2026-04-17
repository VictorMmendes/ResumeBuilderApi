class CreateExperiencePositionBullets < ActiveRecord::Migration[8.1]
  def change
    create_table :experience_position_bullets do |t|
      t.references :experience_position, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :display_order, null: false

      t.timestamps
    end

    add_index :experience_position_bullets, [ :experience_position_id, :display_order ], unique: true
  end
end
