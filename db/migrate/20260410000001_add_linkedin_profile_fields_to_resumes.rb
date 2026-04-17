class AddLinkedinProfileFieldsToResumes < ActiveRecord::Migration[8.1]
  def change
    add_column :resumes, :headline, :string
    add_column :resumes, :street_address, :string
    add_column :resumes, :city, :string
    add_column :resumes, :region, :string
    add_column :resumes, :country, :string
    add_column :resumes, :portfolio_label, :string
  end
end
