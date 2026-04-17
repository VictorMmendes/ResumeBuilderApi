require "test_helper"

class TopSkillTest < ActiveSupport::TestCase
  test "requires name and display_order" do
    top_skill = TopSkill.new(resume: resumes(:one), name: nil, display_order: nil)

    assert_not top_skill.valid?
    assert_includes top_skill.errors[:name], "can't be blank"
    assert_includes top_skill.errors[:display_order], "can't be blank"
  end

  test "ordered scope sorts by display_order" do
    resume = resumes(:one)
    resume.top_skills.create!(name: "Architecture", display_order: 1)
    resume.top_skills.create!(name: "Rails", display_order: 0)

    assert_equal [ "Rails", "Architecture" ], TopSkill.where(resume: resume).ordered.pluck(:name)
  end
end
