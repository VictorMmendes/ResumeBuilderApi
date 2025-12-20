class Resume < ApplicationRecord
  belongs_to :user

  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :softwares, dependent: :destroy
  has_many :languages, dependent: :destroy
  has_many :technical_skills, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :hobbies, dependent: :destroy

  has_one_attached :avatar

  def avatar_url
    Rails.application.routes.url_helpers.url_for(avatar) if avatar.attached?
  end
end
