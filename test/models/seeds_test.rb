require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  test "creates the main resume in the linkedin format" do
    load Rails.root.join("db/seeds.rb")

    resume = Resume.find_by!(full_name: "Victor Mendes Martins")

    assert_equal "victormmendes.vm@icloud.com", resume.email
    assert_equal 5, resume.top_skills.count
    assert_equal 2, resume.certifications.count
    assert_equal 3, resume.educations.count
    assert_equal 3, resume.experience_groups.count

    puzl_place = resume.experience_groups.find_by!(company_name: "PUZL Place")
    assert_equal 2, puzl_place.experience_positions.count
    assert_equal(
      [
        "Frontend Software Engineer | Vue.js, TypeScript & UX Delivery",
        "Fullstack Software Engineer (Backend-Focused) | Vue.js, TypeScript & Laravel"
      ],
      puzl_place.experience_positions.ordered.pluck(:title)
    )
    assert_equal 2, puzl_place.experience_positions.ordered.last.experience_position_bullets.count
  end
end
