require "test_helper"

class ResumePayloadBuilderTest < ActiveSupport::TestCase
  test "builds the linkedin payload with ordered nested data" do
    resume = resumes(:two)

    payload = ResumePayloadBuilder.new(resume).call

    assert_equal resume.id, payload[:id]
    assert_equal resume.full_name, payload[:full_name]
    assert_equal resume.headline, payload[:headline]
    assert_equal(
      {
        street_address: resume.street_address,
        city: resume.city,
        region: resume.region,
        country: resume.country,
        phone: resume.phone,
        email: resume.email,
        linkedin_url: resume.linkedin_url,
        github_url: resume.github_url,
        portfolio_label: resume.portfolio_label
      },
      payload[:contact]
    )
    assert_equal [ "Product Management", "Stakeholder Communication", "Product Strategy" ], payload[:top_skills].map { |skill| skill[:name] }
    assert_equal [ "PSPO I", "PMC Level II" ], payload[:certifications].map { |certification| certification[:name] }
    assert_equal [ "Remote Labs", "Product Studio" ], payload[:experience_groups].map { |group| group[:company_name] }
    assert_equal [ "Lead Product Manager", "Senior Product Manager" ], payload[:experience_groups].first[:positions].map { |position| position[:title] }
    assert_equal [ "Scaled cross-functional delivery rituals", "Launched roadmap planning for three squads" ], payload[:experience_groups].first[:positions].first[:bullets].map { |bullet| bullet[:content] }
    assert_equal [ "Executive Program", "Product School" ], payload[:educations].map { |education| education[:institution] }
    assert_equal Date.new(2022, 8, 1), payload[:experience_groups].first[:positions].first[:start_date]
  end

  test "omits legacy resume fields from the aggregated payload" do
    payload = ResumePayloadBuilder.new(resumes(:one)).call

    %i[title job_title address website_url old_experiences_summary skills softwares languages technical_skills projects hobbies].each do |legacy_key|
      refute_includes payload.keys, legacy_key
    end
  end

  test "returns empty collections for resumes without nested records" do
    resume = Resume.create!(
      user: users(:one),
      full_name: "Builder Only",
      headline: "Architect",
      summary: "No nested records",
      email: "builder@example.com"
    )

    payload = ResumePayloadBuilder.new(resume).call

    assert_equal [], payload[:top_skills]
    assert_equal [], payload[:certifications]
    assert_equal [], payload[:experience_groups]
    assert_equal [], payload[:educations]
  end
end
