require "test_helper"

class ResumeTest < ActiveSupport::TestCase
  test "requires full_name" do
    resume = resumes(:one)
    resume.full_name = nil

    assert_not resume.valid?
    assert_includes resume.errors[:full_name], "can't be blank"
  end

  test "accepts blank linkedin and github urls" do
    resume = resumes(:one)
    resume.linkedin_url = nil
    resume.github_url = nil

    assert resume.valid?
  end

  test "validates linkedin_url format" do
    resume = resumes(:one)
    resume.linkedin_url = "linkedin-profile"

    assert_not resume.valid?
    assert_includes resume.errors[:linkedin_url], "must be a valid HTTP or HTTPS URL"
  end

  test "validates github_url format" do
    resume = resumes(:one)
    resume.github_url = "github-profile"

    assert_not resume.valid?
    assert_includes resume.errors[:github_url], "must be a valid HTTP or HTTPS URL"
  end

  test "orders nested resources by display_order" do
    resume = resumes(:one)
    resume.top_skills.create!(name: "Architecture", display_order: 2)
    resume.top_skills.create!(name: "Rails", display_order: 0)
    resume.top_skills.create!(name: "PostgreSQL", display_order: 1)

    assert_equal [ "Rails", "PostgreSQL", "Architecture" ], resume.reload.top_skills.pluck(:name)
  end
end
