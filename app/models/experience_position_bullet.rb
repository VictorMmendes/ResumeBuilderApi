class ExperiencePositionBullet < ApplicationRecord
  belongs_to :experience_position

  scope :ordered, -> { order(:display_order) }

  validates :content, presence: true
  validates :display_order, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
