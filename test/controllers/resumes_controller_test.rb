require "test_helper"

class ResumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resume = resumes(:two)
  end

  test "should get index" do
    get resumes_url, as: :json
    assert_response :success
  end

  test "should create resume with only linkedin profile attributes" do
    assert_difference("Resume.count") do
      post resumes_url, params: {
        resume: {
          city: @resume.city,
          country: @resume.country,
          email: @resume.email,
          full_name: @resume.full_name,
          github_url: @resume.github_url,
          headline: @resume.headline,
          linkedin_url: @resume.linkedin_url,
          phone: @resume.phone,
          portfolio_label: @resume.portfolio_label,
          region: @resume.region,
          street_address: @resume.street_address,
          summary: @resume.summary,
          title: "Legacy title",
          job_title: "Legacy job title",
          address: "Legacy address",
          website_url: "https://legacy.example.com",
          old_experiences_summary: "Legacy experiences",
          user_id: @resume.user_id
        }
      }, as: :json
    end

    assert_response :created
    created_resume = Resume.order(:id).last

    %w[title job_title address website_url old_experiences_summary].each do |legacy_attribute|
      refute created_resume.has_attribute?(legacy_attribute)
    end
  end

  test "should show aggregated resume payload" do
    get resume_url(@resume), as: :json

    assert_response :success
    body = response.parsed_body

    assert_equal @resume.full_name, body["full_name"]
    assert_equal @resume.headline, body["headline"]
    assert_equal @resume.city, body.dig("contact", "city")
    assert_equal [ "Product Management", "Stakeholder Communication", "Product Strategy" ], body["top_skills"].map { |skill| skill["name"] }
    assert_equal [ "PSPO I", "PMC Level II" ], body["certifications"].map { |certification| certification["name"] }
    assert_equal [ "Remote Labs", "Product Studio" ], body["experience_groups"].map { |group| group["company_name"] }
    assert_equal [ "Lead Product Manager", "Senior Product Manager" ], body["experience_groups"].first["positions"].map { |position| position["title"] }
    assert_equal [ "Scaled cross-functional delivery rituals", "Launched roadmap planning for three squads" ], body["experience_groups"].first["positions"].first["bullets"].map { |bullet| bullet["content"] }
    assert_equal [ "Executive Program", "Product School" ], body["educations"].map { |education| education["institution"] }

    %w[title job_title address website_url old_experiences_summary skills softwares languages technical_skills projects hobbies].each do |legacy_key|
      refute_includes body.keys, legacy_key
    end
  end

  test "should update resume without permitting legacy attributes" do
    patch resume_url(@resume), params: {
      resume: {
        city: "Curitiba",
        country: @resume.country,
        email: @resume.email,
        full_name: @resume.full_name,
        github_url: @resume.github_url,
        headline: "Principal Product Manager",
        linkedin_url: @resume.linkedin_url,
        phone: @resume.phone,
        portfolio_label: @resume.portfolio_label,
        region: @resume.region,
        street_address: @resume.street_address,
        summary: @resume.summary,
        title: "Changed legacy title",
        job_title: "Changed legacy job title",
        address: "Changed legacy address",
        website_url: "https://changed.example.com",
        old_experiences_summary: "Changed legacy summary",
        user_id: @resume.user_id
      }
    }, as: :json

    assert_response :success

    @resume.reload
    assert_equal "Curitiba", @resume.city
    assert_equal "Principal Product Manager", @resume.headline
    %w[title job_title address website_url old_experiences_summary].each do |legacy_attribute|
      refute @resume.has_attribute?(legacy_attribute)
    end
  end

  test "should export pdf using the aggregated payload source" do
    resume = Resume.create!(
      user: users(:one),
      full_name: "Empty Resume",
      headline: "Consultant",
      summary: "Minimal payload for export",
      email: "empty@example.com"
    )
    captured_html = nil
    fake_pdf = Struct.new(:content) do
      def to_pdf
        content
      end
    end

    original_grover_new = Grover.method(:new)
    Grover.define_singleton_method(:new) do |html|
      captured_html = html
      fake_pdf.new("%PDF-1.4 fake")
    end

    begin
      get export_resume_url(resume)
    ensure
      Grover.define_singleton_method(:new, original_grover_new)
    end

    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert_equal "%PDF-1.4 fake", response.body
    assert_includes captured_html, "Empty Resume"
    assert_includes captured_html, "Nenhuma experiencia cadastrada."
    assert_includes captured_html, "Nenhuma top skill cadastrada."
    assert_match(/<main class="main-column">.*Resumo profissional.*Experiência profissional.*Educação.*Top skills.*Certificações/m, captured_html)
    assert_match(/<aside class="sidebar-column">\s*<section class="sidebar-panel contact-panel">.*Contato.*<\/section>\s*<section class="sidebar-panel profile-panel">/m, captured_html)
    refute_includes captured_html, "Soft Skills"
  end

  test "should destroy resume" do
    assert_difference("Resume.count", -1) do
      delete resume_url(@resume), as: :json
    end

    assert_response :no_content
  end
end
