require "test_helper"

class ExperiencePositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @experience_group = experience_groups(:remote_labs)
    @experience_position = experience_positions(:lead_pm)
  end

  test "should get index ordered by display_order" do
    get experience_group_experience_positions_url(@experience_group), as: :json

    assert_response :success
    assert_equal [ experience_positions(:lead_pm).id, experience_positions(:senior_pm).id ], JSON.parse(response.body).map { |position| position["id"] }
  end

  test "should return not found when parent experience_group does not exist" do
    get experience_group_experience_positions_url(-1), as: :json

    assert_response :not_found
  end

  test "should create experience_position" do
    assert_difference("ExperiencePosition.count") do
      post experience_group_experience_positions_url(@experience_group), params: {
        experience_position: {
          title: "Principal Product Manager",
          start_date: Date.new(2024, 1, 1),
          end_date: nil,
          current: true,
          summary: "Expanded platform governance.",
          display_order: 2,
          experience_group_id: experience_groups(:product_studio).id
        }
      }, as: :json
    end

    assert_response :created
    assert_equal @experience_group.id, ExperiencePosition.order(:id).last.experience_group_id
  end

  test "should not create invalid experience_position" do
    assert_no_difference("ExperiencePosition.count") do
      post experience_group_experience_positions_url(@experience_group), params: {
        experience_position: {
          title: "",
          start_date: Date.new(2024, 1, 1),
          end_date: Date.new(2023, 1, 1),
          current: false,
          summary: "Expanded platform governance.",
          display_order: nil
        }
      }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show experience_position" do
    get experience_position_url(@experience_position), as: :json

    assert_response :success
  end

  test "should update experience_position" do
    patch experience_position_url(@experience_position), params: {
      experience_position: {
        title: "Director of Product",
        start_date: @experience_position.start_date,
        end_date: nil,
        current: true,
        summary: @experience_position.summary,
        display_order: @experience_position.display_order
      }
    }, as: :json

    assert_response :success
    assert_equal "Director of Product", @experience_position.reload.title
  end

  test "should destroy experience_position" do
    assert_difference("ExperiencePosition.count", -1) do
      delete experience_position_url(@experience_position), as: :json
    end

    assert_response :no_content
  end
end
