class Meeting < ApplicationRecord
  belongs_to :user_role
  delegate :user, to: :user_role
  belongs_to :project
  has_many :meeting_participants, dependent: :destroy
  has_many :user_roles, through: :meeting_participants

  validates :title, :datetime, :duration, :address, presence: true

  validate :datetime_is_future

  def start_time
    datetime
  end

  private

  def datetime_is_future
    errors.add(:datetime, 'deve ser futuro.') if datetime.present? && datetime < Time.zone.now
  end
end
