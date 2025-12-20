class CreateHobbies < ActiveRecord::Migration[8.1]
  def change
    create_table :hobbies do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :category
      t.string :name

      t.timestamps
    end
  end
end
