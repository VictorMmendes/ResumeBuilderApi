class DropLegacyResumeDomainStructures < ActiveRecord::Migration[8.1]
  def up
    remove_column :resumes, :title, :string
    remove_column :resumes, :job_title, :string
    remove_column :resumes, :address, :string
    remove_column :resumes, :website_url, :string
    remove_column :resumes, :old_experiences_summary, :string

    remove_column :educations, :degree, :string
    remove_column :educations, :location, :string

    drop_table :experiences
    drop_table :skills
    drop_table :softwares
    drop_table :languages
    drop_table :technical_skills
    drop_table :projects
    drop_table :hobbies
  end

  def down
    create_table :experiences do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :job_title
      t.string :company
      t.string :location
      t.date :start_date
      t.date :end_date
      t.boolean :current
      t.text :description

      t.timestamps
    end

    create_table :skills do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name
      t.integer :level

      t.timestamps
    end

    create_table :softwares do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name
      t.integer :level

      t.timestamps
    end

    create_table :languages do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :name
      t.integer :level

      t.timestamps
    end

    create_table :technical_skills do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :category
      t.string :name

      t.timestamps
    end

    create_table :projects do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end

    create_table :hobbies do |t|
      t.references :resume, null: false, foreign_key: true
      t.string :category
      t.string :name

      t.timestamps
    end

    add_column :educations, :degree, :string
    add_column :educations, :location, :string

    add_column :resumes, :title, :string
    add_column :resumes, :job_title, :string
    add_column :resumes, :address, :string
    add_column :resumes, :website_url, :string
    add_column :resumes, :old_experiences_summary, :string
  end
end
