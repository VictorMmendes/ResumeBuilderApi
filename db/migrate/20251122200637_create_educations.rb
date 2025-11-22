class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :institution
      t.string :degree
      t.string :location
      t.date :start_date
      t.date :end_date
      t.boolean :current

      t.timestamps
    end
  end
end
