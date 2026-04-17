class BackfillLinkedinProfileDomain < ActiveRecord::Migration[8.1]
  class MigrationResume < ApplicationRecord
    self.table_name = "resumes"
  end

  class MigrationEducation < ApplicationRecord
    self.table_name = "educations"
  end

  class MigrationExperience < ApplicationRecord
    self.table_name = "experiences"
  end

  class MigrationExperienceGroup < ApplicationRecord
    self.table_name = "experience_groups"
  end

  class MigrationExperiencePosition < ApplicationRecord
    self.table_name = "experience_positions"
  end

  class MigrationExperiencePositionBullet < ApplicationRecord
    self.table_name = "experience_position_bullets"
  end

  class MigrationSkill < ApplicationRecord
    self.table_name = "skills"
  end

  class MigrationTopSkill < ApplicationRecord
    self.table_name = "top_skills"
  end

  def up
    MigrationResume.reset_column_information
    MigrationEducation.reset_column_information

    say_with_time "Backfilling LinkedIn profile fields on resumes" do
      MigrationResume.find_each do |resume|
        attributes = {}
        attributes[:headline] = resume.job_title if resume.headline.blank? && resume.job_title.present?
        attributes[:street_address] = resume.address if resume.street_address.blank? && resume.address.present?

        resume.update_columns(attributes) if attributes.any?
      end
    end

    say_with_time "Backfilling LinkedIn education fields" do
      MigrationEducation.find_each.with_index do |education, index|
        updates = {}
        updates[:degree_name] = education.degree if education.degree_name.blank? && education.degree.present?
        updates[:display_order] = index if education.display_order.nil?

        education.update_columns(updates) if updates.any?
      end

      execute <<~SQL.squish
        WITH ordered AS (
          SELECT
            id,
            ROW_NUMBER() OVER (
              PARTITION BY resume_id
              ORDER BY display_order ASC NULLS LAST, start_date ASC NULLS LAST, created_at ASC, id ASC
            ) - 1 AS normalized_display_order
          FROM educations
        )
        UPDATE educations
        SET display_order = ordered.normalized_display_order
        FROM ordered
        WHERE educations.id = ordered.id
      SQL
    end

    say_with_time "Backfilling top skills from legacy skills" do
      MigrationResume.find_each do |resume|
        next if MigrationTopSkill.where(resume_id: resume.id).exists?

        MigrationSkill.where(resume_id: resume.id).order(:created_at, :id).each_with_index do |skill, index|
          MigrationTopSkill.create!(
            resume_id: resume.id,
            name: skill.name,
            display_order: index
          )
        end
      end
    end

    say_with_time "Backfilling grouped experiences from legacy experiences" do
      MigrationResume.find_each do |resume|
        next if MigrationExperienceGroup.where(resume_id: resume.id).exists?

        legacy_experiences = MigrationExperience.where(resume_id: resume.id).order(:start_date, :created_at, :id)
        next if legacy_experiences.empty?

        legacy_experiences.group_by(&:company).each_with_index do |(company_name, experiences), group_index|
          group = MigrationExperienceGroup.create!(
            resume_id: resume.id,
            company_name: company_name.presence || "Company #{group_index + 1}",
            location: experiences.find { |experience| experience.location.present? }&.location,
            display_order: group_index
          )

          experiences.each_with_index do |experience, position_index|
            bullets = experience.description.to_s.lines.map(&:strip).reject(&:blank?)

            position = MigrationExperiencePosition.create!(
              experience_group_id: group.id,
              title: experience.job_title.presence || "Role #{position_index + 1}",
              start_date: experience.start_date || experience.created_at.to_date,
              end_date: experience.current ? nil : experience.end_date,
              current: !!experience.current,
              summary: bullets.many? ? nil : bullets.first,
              display_order: position_index
            )

            bullets.each_with_index do |content, bullet_index|
              MigrationExperiencePositionBullet.create!(
                experience_position_id: position.id,
                content: content,
                display_order: bullet_index
              )
            end
          end
        end
      end
    end
  end

  def down
    MigrationResume.reset_column_information
    MigrationEducation.reset_column_information

    MigrationResume.find_each do |resume|
      attributes = {}
      attributes[:job_title] = resume.headline if column_exists?(:resumes, :job_title) && resume.headline.present?
      attributes[:address] = resume.street_address if column_exists?(:resumes, :address) && resume.street_address.present?

      resume.update_columns(attributes) if attributes.any?
    end

    MigrationEducation.find_each do |education|
      next unless column_exists?(:educations, :degree)
      next if education.degree_name.blank?

      education.update_columns(degree: education.degree_name)
    end
  end
end
