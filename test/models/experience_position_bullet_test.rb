require "test_helper"

class ExperiencePositionBulletTest < ActiveSupport::TestCase
  test "requires content and display_order" do
    group = resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0)
    position = group.experience_positions.create!(
      title: "Engineer",
      start_date: Date.new(2023, 1, 1),
      current: true,
      display_order: 0
    )
    bullet = position.experience_position_bullets.build(content: nil, display_order: nil)

    assert_not bullet.valid?
    assert_includes bullet.errors[:content], "can't be blank"
    assert_includes bullet.errors[:display_order], "can't be blank"
  end

  test "ordered scope sorts by display_order" do
    group = resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0)
    position = group.experience_positions.create!(
      title: "Engineer",
      start_date: Date.new(2023, 1, 1),
      current: true,
      display_order: 0
    )
    position.experience_position_bullets.create!(content: "Second bullet", display_order: 1)
    position.experience_position_bullets.create!(content: "First bullet", display_order: 0)

    assert_equal [ "First bullet", "Second bullet" ], position.reload.experience_position_bullets.pluck(:content)
  end
end
