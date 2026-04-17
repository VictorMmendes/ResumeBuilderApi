class CreateTopSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :top_skills do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :display_order, null: false

      t.timestamps
    end

    add_index :top_skills, [ :resume_id, :display_order ], unique: true
  end
end
