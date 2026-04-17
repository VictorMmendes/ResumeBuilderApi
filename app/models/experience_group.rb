class ExperienceGroup < ApplicationRecord
  belongs_to :resume
  has_many :experience_positions, -> { ordered }, dependent: :destroy

  scope :ordered, -> { order(:display_order) }

  validates :company_name, presence: true
  validates :display_order, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
