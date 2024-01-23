class Task < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :assigned, class_name: 'User', optional: true

  enum status: { uninitialized: 0, in_progress: 3, finished: 5, expired: 7, cancelled: 9 }

  validates :title, presence: true

  validate :due_date_is_future

  private

  def due_date_is_future
    errors.add(:due_date, ' deve ser futuro.') if due_date.present? && due_date < Time.zone.today.to_date
  end
end
