class Meeting < ApplicationRecord
  belongs_to :user_role
  belongs_to :project

  validates :title, :datetime, :duration, :address, presence: true

  validate :datetime_is_future

  private

  def datetime_is_future
    errors.add(:datetime, 'deve ser futuro.') if datetime.present? && datetime < Time.zone.now
  end
end
