class CreateCertifications < ActiveRecord::Migration[8.1]
  def change
    create_table :certifications do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :display_order, null: false

      t.timestamps
    end

    add_index :certifications, [ :resume_id, :display_order ], unique: true
  end
end
