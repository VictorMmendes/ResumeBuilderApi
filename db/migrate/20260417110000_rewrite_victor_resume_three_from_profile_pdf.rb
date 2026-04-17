require_relative "../support/victor_linkedin_profile_20260417"

class RewriteVictorResumeThreeFromProfilePdf < ActiveRecord::Migration[8.1]
  class MigrationResume < ApplicationRecord
    self.table_name = "resumes"
  end

  class MigrationEducation < ApplicationRecord
    self.table_name = "educations"
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

  class MigrationTopSkill < ApplicationRecord
    self.table_name = "top_skills"
  end

  class MigrationCertification < ApplicationRecord
    self.table_name = "certifications"
  end

  def up
    resume = find_target_resume
    unless resume
      say "Victor resume not found. Skipping LinkedIn Profile.pdf rewrite.", true
      return
    end

    say_with_time "Rewriting resume ##{resume.id} from .artefacts/Profile.pdf" do
      timestamp = Time.current

      MigrationResume.transaction do
        resume.update_columns(
          VictorLinkedinProfile20260417::RESUME_ATTRIBUTES.merge(updated_at: timestamp)
        )

        delete_resume_domain_records(resume.id)
        insert_top_skills(resume.id, timestamp)
        insert_certifications(resume.id, timestamp)
        insert_experience_groups(resume.id, timestamp)
        insert_educations(resume.id, timestamp)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Victor resume rewrite mirrors the exported LinkedIn PDF and cannot be reverted automatically."
  end

  private

  def find_target_resume
    resume = MigrationResume.find_by(id: 3)
    return resume if victor_resume?(resume)

    MigrationResume.find_by(VictorLinkedinProfile20260417::MATCH_ATTRIBUTES)
  end

  def victor_resume?(resume)
    return false if resume.nil?

    VictorLinkedinProfile20260417::MATCH_ATTRIBUTES.all? do |attribute, expected_value|
      resume.public_send(attribute) == expected_value
    end
  end

  def delete_resume_domain_records(resume_id)
    group_ids = MigrationExperienceGroup.where(resume_id: resume_id).select(:id)
    position_ids = MigrationExperiencePosition.where(experience_group_id: group_ids).select(:id)

    MigrationExperiencePositionBullet.where(experience_position_id: position_ids).delete_all
    MigrationExperiencePosition.where(id: position_ids).delete_all
    MigrationExperienceGroup.where(id: group_ids).delete_all
    MigrationCertification.where(resume_id: resume_id).delete_all
    MigrationTopSkill.where(resume_id: resume_id).delete_all
    MigrationEducation.where(resume_id: resume_id).delete_all
  end

  def insert_top_skills(resume_id, timestamp)
    VictorLinkedinProfile20260417::TOP_SKILLS.each_with_index do |name, index|
      MigrationTopSkill.create!(
        resume_id: resume_id,
        name: name,
        display_order: index,
        created_at: timestamp,
        updated_at: timestamp
      )
    end
  end

  def insert_certifications(resume_id, timestamp)
    VictorLinkedinProfile20260417::CERTIFICATIONS.each_with_index do |name, index|
      MigrationCertification.create!(
        resume_id: resume_id,
        name: name,
        display_order: index,
        created_at: timestamp,
        updated_at: timestamp
      )
    end
  end

  def insert_experience_groups(resume_id, timestamp)
    VictorLinkedinProfile20260417::EXPERIENCE_GROUPS.each_with_index do |group_attributes, group_index|
      group = MigrationExperienceGroup.create!(
        resume_id: resume_id,
        company_name: group_attributes[:company_name],
        location: group_attributes[:location],
        display_order: group_index,
        created_at: timestamp,
        updated_at: timestamp
      )

      group_attributes[:positions].each_with_index do |position_attributes, position_index|
        position = MigrationExperiencePosition.create!(
          experience_group_id: group.id,
          title: position_attributes[:title],
          start_date: position_attributes[:start_date],
          end_date: position_attributes[:end_date],
          current: position_attributes[:current],
          summary: position_attributes[:summary],
          display_order: position_index,
          created_at: timestamp,
          updated_at: timestamp
        )

        position_attributes[:bullets].each_with_index do |content, bullet_index|
          MigrationExperiencePositionBullet.create!(
            experience_position_id: position.id,
            content: content,
            display_order: bullet_index,
            created_at: timestamp,
            updated_at: timestamp
          )
        end
      end
    end
  end

  def insert_educations(resume_id, timestamp)
    VictorLinkedinProfile20260417::EDUCATIONS.each_with_index do |education_attributes, index|
      MigrationEducation.create!(
        education_attributes.merge(
          resume_id: resume_id,
          display_order: index,
          created_at: timestamp,
          updated_at: timestamp
        )
      )
    end
  end
end
