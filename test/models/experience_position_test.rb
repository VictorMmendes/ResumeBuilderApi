require "test_helper"

class ExperiencePositionTest < ActiveSupport::TestCase
  test "requires title start_date and display_order" do
    position = ExperiencePosition.new(
      experience_group: resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0),
      title: nil,
      start_date: nil,
      display_order: nil
    )

    assert_not position.valid?
    assert_includes position.errors[:title], "can't be blank"
    assert_includes position.errors[:start_date], "can't be blank"
    assert_includes position.errors[:display_order], "can't be blank"
  end

  test "validates end_date after start_date" do
    group = resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0)
    position = group.experience_positions.build(
      title: "Engineer",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2023, 1, 1),
      current: false,
      display_order: 0
    )

    assert_not position.valid?
    assert_includes position.errors[:end_date], "must be on or after the start date"
  end

  test "requires end_date to be blank when current" do
    group = resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0)
    position = group.experience_positions.build(
      title: "Engineer",
      start_date: Date.new(2024, 1, 1),
      end_date: Date.new(2024, 2, 1),
      current: true,
      display_order: 0
    )

    assert_not position.valid?
    assert_includes position.errors[:end_date], "must be blank when the position is current"
  end

  test "ordered scope sorts by display_order" do
    group = resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0)
    group.experience_positions.create!(
      title: "Senior Engineer",
      start_date: Date.new(2023, 1, 1),
      current: false,
      end_date: Date.new(2023, 12, 1),
      display_order: 1
    )
    group.experience_positions.create!(
      title: "Staff Engineer",
      start_date: Date.new(2024, 1, 1),
      current: true,
      display_order: 0
    )

    assert_equal [ "Staff Engineer", "Senior Engineer" ], group.reload.experience_positions.pluck(:title)
  end
end
