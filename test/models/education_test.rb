require "test_helper"

class EducationTest < ActiveSupport::TestCase
  test "requires institution" do
    education = educations(:one)
    education.institution = nil

    assert_not education.valid?
    assert_includes education.errors[:institution], "can't be blank"
  end

  test "requires display_order" do
    education = educations(:one)
    education.display_order = nil

    assert_not education.valid?
    assert_includes education.errors[:display_order], "can't be blank"
  end

  test "validates end_date after start_date" do
    education = educations(:one)
    education.start_date = Date.new(2024, 1, 1)
    education.end_date = Date.new(2023, 12, 1)

    assert_not education.valid?
    assert_includes education.errors[:end_date], "must be on or after the start date"
  end

  test "ordered scope sorts by display_order" do
    resume = resumes(:one)
    resume.educations.create!(
      institution: "Second institution",
      degree_name: "Postgraduate",
      field_of_study: "Engineering",
      start_date: Date.new(2023, 1, 1),
      end_date: Date.new(2023, 12, 1),
      current: false,
      display_order: 2
    )
    resume.educations.create!(
      institution: "First institution",
      degree_name: "Bootcamp",
      field_of_study: "Backend",
      start_date: Date.new(2022, 1, 1),
      end_date: Date.new(2022, 12, 1),
      current: false,
      display_order: 1
    )

    assert_equal [ 0, 1, 2 ], resume.reload.educations.ordered.pluck(:display_order)
  end
end
