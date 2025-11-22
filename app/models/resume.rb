class Resume < ApplicationRecord
  belongs_to :user

  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :softwares, dependent: :destroy
  has_many :languages, dependent: :destroy
end
