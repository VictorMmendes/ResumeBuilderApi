class ReshapeEducationsForLinkedinProfile < ActiveRecord::Migration[8.1]
  def up
    add_column :educations, :degree_name, :string
    add_column :educations, :field_of_study, :string
    add_column :educations, :display_order, :integer

    execute <<~SQL.squish
      UPDATE educations
      SET
        degree_name = COALESCE(degree_name, degree),
        display_order = ordered.display_order
      FROM (
        SELECT
          id,
          ROW_NUMBER() OVER (
            PARTITION BY resume_id
            ORDER BY start_date ASC NULLS LAST, created_at ASC, id ASC
          ) - 1 AS display_order
        FROM educations
      ) AS ordered
      WHERE educations.id = ordered.id
    SQL

    change_column_null :educations, :display_order, false
    add_index :educations, [ :resume_id, :display_order ], unique: true
  end

  def down
    remove_index :educations, [ :resume_id, :display_order ]
    remove_column :educations, :display_order
    remove_column :educations, :field_of_study
    remove_column :educations, :degree_name
  end
end
