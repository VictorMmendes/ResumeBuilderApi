require_relative "support/victor_linkedin_profile_20260417"

puts "Resetting LinkedIn-profile resume data..."

ExperiencePositionBullet.destroy_all
ExperiencePosition.destroy_all
ExperienceGroup.destroy_all
Certification.destroy_all
TopSkill.destroy_all
Education.destroy_all
Resume.destroy_all

resume_email = VictorLinkedinProfile20260417::RESUME_ATTRIBUTES[:email]
user = User.where("LOWER(email) = ?", resume_email.downcase).first_or_initialize
user.update!(email: resume_email.downcase)

puts "Creating Victor Mendes Martins resume from Profile.pdf..."

resume = user.resumes.create!(VictorLinkedinProfile20260417::RESUME_ATTRIBUTES)

avatar_path = Rails.root.join("app", "assets", "images", "IMG_7090.jpg")
if File.exist?(avatar_path)
  resume.avatar.attach(
    io: File.open(avatar_path),
    filename: "IMG_7090.jpg",
    content_type: "image/jpeg"
  )
end

VictorLinkedinProfile20260417::TOP_SKILLS.each_with_index do |name, index|
  resume.top_skills.create!(name: name, display_order: index)
end

VictorLinkedinProfile20260417::CERTIFICATIONS.each_with_index do |name, index|
  resume.certifications.create!(name: name, display_order: index)
end

VictorLinkedinProfile20260417::EXPERIENCE_GROUPS.each_with_index do |group_attributes, group_index|
  group = resume.experience_groups.create!(
    company_name: group_attributes[:company_name],
    location: group_attributes[:location],
    display_order: group_index
  )

  group_attributes[:positions].each_with_index do |position_attributes, position_index|
    position = group.experience_positions.create!(
      title: position_attributes[:title],
      start_date: position_attributes[:start_date],
      end_date: position_attributes[:end_date],
      current: position_attributes[:current],
      summary: position_attributes[:summary],
      display_order: position_index
    )

    position_attributes[:bullets].each_with_index do |content, bullet_index|
      position.experience_position_bullets.create!(content: content, display_order: bullet_index)
    end
  end
end

VictorLinkedinProfile20260417::EDUCATIONS.each_with_index do |education_attributes, index|
  resume.educations.create!(education_attributes.merge(display_order: index))
end

puts "Seed completed with Victor Mendes Martins LinkedIn resume."
