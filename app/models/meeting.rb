class Meeting < ApplicationRecord
  belongs_to :user_role
  delegate :user, to: :user_role
  belongs_to :project
  has_many :meeting_participants, dependent: :destroy
  has_many :participants, through: :meeting_participants, source: :user_role

  after_create :scheduling_job
  after_update :scheduling_job

  validates :title, :datetime, :duration, :address, presence: true
  validate :datetime_is_future, on: :create
  validate :five_minutes_ahead, on: :update, if: :datetime_changed?

  def start_time
    datetime
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
