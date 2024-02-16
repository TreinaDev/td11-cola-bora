class Meeting < ApplicationRecord
  belongs_to :user_role, -> { unscope(where: :active) }, inverse_of: :meetings
  delegate :user, to: :user_role
  belongs_to :project
  has_many :meeting_participants, dependent: :destroy
  has_many :participants, through: :meeting_participants, source: :user_role

  after_commit :scheduling_job, on: %i[create update]

  validates :title, :datetime, :duration, :address, presence: true
  validate :datetime_is_future
  validate :five_minutes_ahead, on: :update, if: :datetime_changed?

  def start_time
    datetime
  end

  def starts_soon?(meeting)
    (meeting.datetime - 5.minutes).strftime('%H:%M') == Time.zone.now.strftime('%H:%M')
  end

  private

  def datetime_is_future
    errors.add(:datetime, I18n.t('meetings.should_be_in_future')) if datetime.present? && datetime < Time.zone.now
  end

  def scheduling_job
    NotifyParticipantsJob.set(wait_until: datetime - 5.minutes).perform_later(self)
  end

  def five_minutes_ahead
    return unless datetime <= Time.zone.now + 5.minutes

    errors.add(:datetime,
               I18n.t('meetings.cant_edit_five_minutes_before'))
  end
end
