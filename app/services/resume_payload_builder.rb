class ResumePayloadBuilder
  def initialize(resume)
    @resume = resume
  end

  def call
    {
      id: resume.id,
      full_name: resume.full_name,
      headline: resume.headline,
      summary: resume.summary,
      contact: contact_payload,
      avatar_url: resume.avatar_url,
      top_skills: resume.top_skills.map { |top_skill| ordered_name_payload(top_skill) },
      certifications: resume.certifications.map { |certification| ordered_name_payload(certification) },
      experience_groups: resume.experience_groups.map { |experience_group| experience_group_payload(experience_group) },
      educations: resume.educations.map { |education| education_payload(education) }
    }
  end

  private

  attr_reader :resume

  def contact_payload
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
    }
  end

  def ordered_name_payload(record)
    {
      id: record.id,
      name: record.name,
      display_order: record.display_order
    }
  end

  def experience_group_payload(experience_group)
    {
      id: experience_group.id,
      company_name: experience_group.company_name,
      location: experience_group.location,
      display_order: experience_group.display_order,
      positions: experience_group.experience_positions.map { |experience_position| experience_position_payload(experience_position) }
    }
  end

  def experience_position_payload(experience_position)
    {
      id: experience_position.id,
      title: experience_position.title,
      start_date: experience_position.start_date,
      end_date: experience_position.end_date,
      current: experience_position.current,
      summary: experience_position.summary,
      display_order: experience_position.display_order,
      bullets: experience_position.experience_position_bullets.map do |bullet|
        {
          id: bullet.id,
          content: bullet.content,
          display_order: bullet.display_order
        }
      end
    }
  end

  def education_payload(education)
    {
      id: education.id,
      institution: education.institution,
      degree_name: education.degree_name,
      field_of_study: education.field_of_study,
      start_date: education.start_date,
      end_date: education.end_date,
      current: education.current,
      display_order: education.display_order
    }
  end
end
