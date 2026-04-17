require "test_helper"

class EducationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resume = resumes(:two)
    @education = educations(:three)
  end

  test "should get index ordered by display_order" do
    get resume_educations_url(@resume), as: :json
    assert_response :success

    assert_equal [ educations(:three).id, educations(:two).id ], JSON.parse(response.body).map { |education| education["id"] }
  end

  test "should return not found when parent resume does not exist" do
    get resume_educations_url(-1), as: :json

    assert_response :not_found
  end

  test "should create education" do
    assert_difference("Education.count") do
      post resume_educations_url(@resume), params: {
        education: {
          institution: "New School",
          degree_name: "Specialization",
          field_of_study: "Systems Design",
          start_date: Date.new(2021, 2, 1),
          end_date: Date.new(2022, 12, 1),
          current: false,
          display_order: 2,
          resume_id: resumes(:one).id
        }
      }, as: :json
    end

    assert_response :created
    assert_equal @resume.id, Education.order(:id).last.resume_id
  end

  test "should not create invalid education" do
    assert_no_difference("Education.count") do
      post resume_educations_url(@resume), params: {
        education: {
          institution: "",
          degree_name: "Specialization",
          field_of_study: "Systems Design",
          start_date: Date.new(2022, 1, 1),
          end_date: Date.new(2021, 12, 1),
          current: false,
          display_order: 2
        }
      }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show education" do
    get education_url(@education), as: :json
    assert_response :success
  end

  test "should update education" do
    patch education_url(@education), params: {
      education: {
        institution: "Updated Institution",
        degree_name: @education.degree_name,
        field_of_study: "Leadership",
        start_date: @education.start_date,
        end_date: @education.end_date,
        current: @education.current,
        display_order: @education.display_order
      }
    }, as: :json
    assert_response :success
    assert_equal "Updated Institution", @education.reload.institution
  end

  test "should destroy education" do
    assert_difference("Education.count", -1) do
      delete education_url(@education), as: :json
    end

    assert_response :no_content
  end
end
