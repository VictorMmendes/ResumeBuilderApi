require "test_helper"

class ExperiencePositionBulletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @experience_position = experience_positions(:lead_pm)
    @experience_position_bullet = experience_position_bullets(:lead_pm_first)
  end

  test "should get index ordered by display_order" do
    get experience_position_experience_position_bullets_url(@experience_position), as: :json

    assert_response :success
    assert_equal [ experience_position_bullets(:lead_pm_first).id, experience_position_bullets(:lead_pm_second).id ], JSON.parse(response.body).map { |bullet| bullet["id"] }
  end

  test "should return not found when parent experience_position does not exist" do
    get experience_position_experience_position_bullets_url(-1), as: :json

    assert_response :not_found
  end

  test "should create experience_position_bullet" do
    assert_difference("ExperiencePositionBullet.count") do
      post experience_position_experience_position_bullets_url(@experience_position), params: {
        experience_position_bullet: {
          content: "Strengthened roadmap alignment with commercial teams",
          display_order: 2,
          experience_position_id: experience_positions(:senior_pm).id
        }
      }, as: :json
    end

    assert_response :created
    assert_equal @experience_position.id, ExperiencePositionBullet.order(:id).last.experience_position_id
  end

  test "should not create invalid experience_position_bullet" do
    assert_no_difference("ExperiencePositionBullet.count") do
      post experience_position_experience_position_bullets_url(@experience_position), params: {
        experience_position_bullet: {
          content: "",
          display_order: nil
        }
      }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show experience_position_bullet" do
    get experience_position_bullet_url(@experience_position_bullet), as: :json

    assert_response :success
  end

  test "should update experience_position_bullet" do
    patch experience_position_bullet_url(@experience_position_bullet), params: {
      experience_position_bullet: {
        content: "Scaled product delivery rituals across multiple squads",
        display_order: @experience_position_bullet.display_order
      }
    }, as: :json

    assert_response :success
    assert_equal "Scaled product delivery rituals across multiple squads", @experience_position_bullet.reload.content
  end

  test "should destroy experience_position_bullet" do
    assert_difference("ExperiencePositionBullet.count", -1) do
      delete experience_position_bullet_url(@experience_position_bullet), as: :json
    end

    assert_response :no_content
  end
end
