class AddFieldsToResumes < ActiveRecord::Migration[8.1]
  def change
    add_column :resumes, :github_url, :string
    add_column :resumes, :old_experiences_summary, :string
  end
end
