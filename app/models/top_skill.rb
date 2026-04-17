class TopSkill < ApplicationRecord
  belongs_to :resume

  scope :ordered, -> { order(:display_order) }

  validates :name, presence: true
  validates :display_order, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
