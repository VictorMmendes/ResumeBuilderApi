require "test_helper"

class SchemaCleanupTest < ActiveSupport::TestCase
  test "removes legacy resume columns from the final schema" do
    resume_columns = ActiveRecord::Base.connection.columns(:resumes).map(&:name)
    education_columns = ActiveRecord::Base.connection.columns(:educations).map(&:name)

    %w[title job_title address website_url old_experiences_summary].each do |column_name|
      refute_includes resume_columns, column_name
    end

    %w[degree location].each do |column_name|
      refute_includes education_columns, column_name
    end
  end

  test "removes legacy tables from the final schema" do
    tables = ActiveRecord::Base.connection.tables

    %w[experiences skills softwares languages technical_skills projects hobbies].each do |table_name|
      refute_includes tables, table_name
    end
  end
end
