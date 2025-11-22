require "test_helper"

class SoftwaresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @software = softwares(:one)
  end

  test "should get index" do
    get softwares_url, as: :json
    assert_response :success
  end

  test "should create software" do
    assert_difference("Software.count") do
      post softwares_url, params: { software: { level: @software.level, name: @software.name, resume_id: @software.resume_id } }, as: :json
    end

    assert_response :created
  end

  test "should show software" do
    get software_url(@software), as: :json
    assert_response :success
  end

  test "should update software" do
    patch software_url(@software), params: { software: { level: @software.level, name: @software.name, resume_id: @software.resume_id } }, as: :json
    assert_response :success
  end

  test "should destroy software" do
    assert_difference("Software.count", -1) do
      delete software_url(@software), as: :json
    end

    assert_response :no_content
  end
end
