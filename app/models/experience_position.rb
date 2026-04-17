class ExperiencePosition < ApplicationRecord
  belongs_to :experience_group
  has_many :experience_position_bullets, -> { ordered }, dependent: :destroy

  scope :ordered, -> { order(:display_order) }

  validates :title, :start_date, presence: true
  validates :current, inclusion: { in: [ true, false ] }
  validates :display_order, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :end_date_must_not_be_before_start_date
  validate :end_date_must_be_blank_when_current

  private

  def end_date_must_not_be_before_start_date
    return if start_date.blank? || end_date.blank?
    return if end_date >= start_date

    errors.add(:end_date, "must be on or after the start date")
  end

  def end_date_must_be_blank_when_current
    return unless current? && end_date.present?

    errors.add(:end_date, "must be blank when the position is current")
  end
end
