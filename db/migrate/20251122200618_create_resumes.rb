class CreateResumes < ActiveRecord::Migration[8.1]
  def change
    create_table :resumes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :full_name
      t.string :job_title
      t.text :summary
      t.string :email
      t.string :phone
      t.string :address
      t.string :linkedin_url
      t.string :website_url

      t.timestamps
    end
  end
end
