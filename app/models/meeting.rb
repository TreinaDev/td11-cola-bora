class Meeting < ApplicationRecord
  belongs_to :user_role
  delegate :user, to: :user_role
  belongs_to :project

  validates :title, :datetime, :duration, :address, presence: true

  validate :datetime_is_future
  validate :five_minutes_ahead, on: :update
  after_create :scheduling_job

  def start_time
    datetime
  end

  private

  def datetime_is_future
    errors.add(:datetime, 'deve ser futuro.') if datetime.present? && datetime < Time.zone.now
  end

  def scheduling_job
    NotifyParticipantsJob.set(wait_until: datetime - 5.minutes).perform_later(self)
  end

  def five_minutes_ahead
    return unless datetime <= Time.zone.now + 5.minutes

    errors.add(:base,
               I18n.t('meetings.cant_edit_five_minutes_before'))
  end
end
