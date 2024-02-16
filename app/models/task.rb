class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user_role, -> { unscope(where: :active) }, inverse_of: :tasks
  delegate :user, to: :user_role
  belongs_to :assigned, class_name: 'User', optional: true
  after_create :expire_task
  after_update :expire_task

  enum status: { uninitialized: 0, in_progress: 3, finished: 5, expired: 7, cancelled: 9 }

  validates :title, presence: true

  validate :due_date_is_future_on_create, on: :create
  validate :due_date_is_future_on_update, on: :update, if: :due_date_changed?

  def start_time
    due_date&.to_datetime
  end

  private

  def due_date_is_future_on_create
    due_date_is_future if due_date.present?
  end

  def due_date_is_future_on_update
    due_date_is_future
  end

  def due_date_is_future
    errors.add(:due_date, 'deve ser futuro.') if due_date.present? && due_date < Time.zone.today.to_date
  end

  def expire_task
    return unless due_date

    ExpireTaskJob.set(wait_until: due_date.tomorrow.beginning_of_day).perform_later(self)
  end
end
