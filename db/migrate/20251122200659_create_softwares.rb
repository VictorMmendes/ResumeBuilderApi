class CreateSoftwares < ActiveRecord::Migration[8.1]
  def change
    create_table :softwares do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name
      t.integer :level

      t.timestamps
    end
  end
end
