require "test_helper"

class ExperiencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @experience = experiences(:one)
  end

  test "should get index" do
    get experiences_url, as: :json
    assert_response :success
  end

  test "should create experience" do
    assert_difference("Experience.count") do
      post experiences_url, params: { experience: { company: @experience.company, current: @experience.current, description: @experience.description, end_date: @experience.end_date, job_title: @experience.job_title, location: @experience.location, resume_id: @experience.resume_id, start_date: @experience.start_date } }, as: :json
    end

    assert_response :created
  end

  test "should show experience" do
    get experience_url(@experience), as: :json
    assert_response :success
  end

  test "should update experience" do
    patch experience_url(@experience), params: { experience: { company: @experience.company, current: @experience.current, description: @experience.description, end_date: @experience.end_date, job_title: @experience.job_title, location: @experience.location, resume_id: @experience.resume_id, start_date: @experience.start_date } }, as: :json
    assert_response :success
  end

  test "should destroy experience" do
    assert_difference("Experience.count", -1) do
      delete experience_url(@experience), as: :json
    end

    assert_response :no_content
  end
end
