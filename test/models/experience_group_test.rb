require "test_helper"

class ExperienceGroupTest < ActiveSupport::TestCase
  test "requires company_name" do
    group = ExperienceGroup.new(resume: resumes(:one), company_name: nil, display_order: 0)

    assert_not group.valid?
    assert_includes group.errors[:company_name], "can't be blank"
  end

  test "requires display_order" do
    group = ExperienceGroup.new(resume: resumes(:one), company_name: "Acme", display_order: nil)

    assert_not group.valid?
    assert_includes group.errors[:display_order], "can't be blank"
  end

  test "ordered scope sorts by display_order" do
    resume = resumes(:one)
    resume.experience_groups.create!(company_name: "Third", display_order: 2)
    resume.experience_groups.create!(company_name: "First", display_order: 0)
    resume.experience_groups.create!(company_name: "Second", display_order: 1)

    assert_equal [ "First", "Second", "Third" ], resume.reload.experience_groups.pluck(:company_name)
  end

  test "destroy cascades to positions and bullets" do
    group = resumes(:one).experience_groups.create!(company_name: "Acme", display_order: 0)
    position = group.experience_positions.create!(
      title: "Engineer",
      start_date: Date.new(2023, 1, 1),
      current: false,
      end_date: Date.new(2023, 12, 1),
      display_order: 0
    )
    bullet = position.experience_position_bullets.create!(content: "Delivered platform work", display_order: 0)

    assert_difference("ExperienceGroup.count", -1) do
      assert_difference("ExperiencePosition.count", -1) do
        assert_difference("ExperiencePositionBullet.count", -1) do
          group.destroy
        end
      end
    end

    assert_nil ExperiencePosition.find_by(id: position.id)
    assert_nil ExperiencePositionBullet.find_by(id: bullet.id)
  end
end
