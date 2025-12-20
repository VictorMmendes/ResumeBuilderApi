class CreateTechnicalSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :technical_skills do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :category
      t.string :name

      t.timestamps
    end
  end
end
