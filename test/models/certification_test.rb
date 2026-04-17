require "test_helper"

class CertificationTest < ActiveSupport::TestCase
  test "requires name and display_order" do
    certification = Certification.new(resume: resumes(:one), name: nil, display_order: nil)

    assert_not certification.valid?
    assert_includes certification.errors[:name], "can't be blank"
    assert_includes certification.errors[:display_order], "can't be blank"
  end

  test "ordered scope sorts by display_order" do
    resume = resumes(:one)
    resume.certifications.create!(name: "AWS", display_order: 1)
    resume.certifications.create!(name: "CKA", display_order: 0)

    assert_equal [ "CKA", "AWS" ], Certification.where(resume: resume).ordered.pluck(:name)
  end
end
