require "test_helper"

class CertificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resume = resumes(:two)
    @certification = certifications(:pspo)
  end

  test "should get index ordered by display_order" do
    @resume.certifications.create!(name: "ICAgile ICP", display_order: 10)
    @resume.certifications.create!(name: "Pragmatic PMC", display_order: 5)

    get resume_certifications_url(@resume), as: :json

    assert_response :success
    assert_equal [ 0, 1, 5, 10 ], JSON.parse(response.body).map { |certification| certification["display_order"] }
  end

  test "should return not found when parent resume does not exist" do
    get resume_certifications_url(-1), as: :json

    assert_response :not_found
  end

  test "should create certification" do
    assert_difference("Certification.count") do
      post resume_certifications_url(@resume), params: {
        certification: {
          name: "PMI ACP",
          display_order: 2,
          resume_id: resumes(:one).id
        }
      }, as: :json
    end

    assert_response :created
    assert_equal @resume.id, Certification.order(:id).last.resume_id
  end

  test "should not create invalid certification" do
    assert_no_difference("Certification.count") do
      post resume_certifications_url(@resume), params: {
        certification: {
          name: "",
          display_order: nil
        }
      }, as: :json
    end

    assert_response :unprocessable_content
  end

  test "should show certification" do
    get certification_url(@certification), as: :json

    assert_response :success
  end

  test "should update certification" do
    patch certification_url(@certification), params: {
      certification: {
        name: "PSPO II",
        display_order: @certification.display_order
      }
    }, as: :json

    assert_response :success
    assert_equal "PSPO II", @certification.reload.name
  end

  test "should destroy certification" do
    assert_difference("Certification.count", -1) do
      delete certification_url(@certification), as: :json
    end

    assert_response :no_content
  end
end
