class Education < ApplicationRecord
  belongs_to :resume

  scope :ordered, -> { order(:display_order) }

  validates :institution, presence: true
  validates :display_order, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :end_date_must_not_be_before_start_date

  private

  def end_date_must_not_be_before_start_date
    return if start_date.blank? || end_date.blank?
    return if end_date >= start_date

    errors.add(:end_date, "must be on or after the start date")
  end
end
