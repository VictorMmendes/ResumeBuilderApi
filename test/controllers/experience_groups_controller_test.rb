require "test_helper"

class ExperienceGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resume = resumes(:two)
    @experience_group = experience_groups(:remote_labs)
  end

  test "should get index ordered by display_order" do
    get resume_experience_groups_url(@resume), as: :json

    assert_response :success
    assert_equal [ experience_groups(:remote_labs).id, experience_groups(:product_studio).id ], JSON.parse(response.body).map { |group| group["id"] }
  end

  test "should return not found when parent resume does not exist" do
    get resume_experience_groups_url(-1), as: :json

    assert_response :not_found
  end

  test "should create experience_group" do
    assert_difference("ExperienceGroup.count") do
      post resume_experience_groups_url(@resume), params: {
        experience_group: {
          company_name: "New Company",
          location: "Curitiba, Brazil",
          display_order: 2,
          resume_id: resumes(:one).id
        }
      }, as: :json
    end

    assert_response :created
    assert_equal @resume.id, ExperienceGroup.order(:id).last.resume_id
  end

  test "should not create invalid experience_group" do
    assert_no_difference("ExperienceGroup.count") do
      post resume_experience_groups_url(@resume), params: {
        experience_group: {
          company_name: "",
          location: "Curitiba, Brazil",
          display_order: nil
        }
      }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show experience_group" do
    get experience_group_url(@experience_group), as: :json

    assert_response :success
  end

  test "should update experience_group" do
    patch experience_group_url(@experience_group), params: {
      experience_group: {
        company_name: "Remote Labs International",
        location: @experience_group.location,
        display_order: @experience_group.display_order
      }
    }, as: :json

    assert_response :success
    assert_equal "Remote Labs International", @experience_group.reload.company_name
  end

  test "should destroy experience_group" do
    assert_difference("ExperienceGroup.count", -1) do
      delete experience_group_url(@experience_group), as: :json
    end

    assert_response :no_content
  end
end
