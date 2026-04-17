require "test_helper"

class TopSkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resume = resumes(:two)
    @top_skill = top_skills(:product_management)
  end

  test "should get index ordered by display_order" do
    @resume.top_skills.create!(name: "Platform Discovery", display_order: 10)
    @resume.top_skills.create!(name: "Customer Research", display_order: 5)

    get resume_top_skills_url(@resume), as: :json

    assert_response :success
    assert_equal [ 0, 1, 2, 5, 10 ], JSON.parse(response.body).map { |skill| skill["display_order"] }
  end

  test "should return not found when parent resume does not exist" do
    get resume_top_skills_url(-1), as: :json

    assert_response :not_found
  end

  test "should create top_skill" do
    assert_difference("TopSkill.count") do
      post resume_top_skills_url(@resume), params: {
        top_skill: {
          name: "Roadmapping",
          display_order: 3,
          resume_id: resumes(:one).id
        }
      }, as: :json
    end

    assert_response :created
    assert_equal @resume.id, TopSkill.order(:id).last.resume_id
  end

  test "should not create invalid top_skill" do
    assert_no_difference("TopSkill.count") do
      post resume_top_skills_url(@resume), params: {
        top_skill: {
          name: "",
          display_order: nil
        }
      }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show top_skill" do
    get top_skill_url(@top_skill), as: :json

    assert_response :success
  end

  test "should update top_skill" do
    patch top_skill_url(@top_skill), params: {
      top_skill: {
        name: "Strategic Product Management",
        display_order: @top_skill.display_order
      }
    }, as: :json

    assert_response :success
    assert_equal "Strategic Product Management", @top_skill.reload.name
  end

  test "should destroy top_skill" do
    assert_difference("TopSkill.count", -1) do
      delete top_skill_url(@top_skill), as: :json
    end

    assert_response :no_content
  end
end
