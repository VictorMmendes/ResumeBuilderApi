class Resume < ApplicationRecord
  belongs_to :user

  has_many :educations, -> { ordered }, dependent: :destroy
  has_many :experience_groups, -> { ordered }, dependent: :destroy
  has_many :top_skills, -> { ordered }, dependent: :destroy
  has_many :certifications, -> { ordered }, dependent: :destroy

  has_one_attached :avatar

  validates :full_name, presence: true
  validate :linkedin_url_must_be_http_url
  validate :github_url_must_be_http_url

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end

  private

  def linkedin_url_must_be_http_url
    validate_http_url(:linkedin_url)
  end

  def github_url_must_be_http_url
    validate_http_url(:github_url)
  end

  def validate_http_url(attribute)
    value = self[attribute]
    return if value.blank?

    uri = URI.parse(value)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(attribute, "must be a valid HTTP or HTTPS URL")
  rescue URI::InvalidURIError
    errors.add(attribute, "must be a valid HTTP or HTTPS URL")
  end
end
