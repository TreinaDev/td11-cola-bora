class Invitation < ApplicationRecord
  belongs_to :project

  validates :project_id, uniqueness: { scope: :profile_id }
  validates :expiration_days, numericality: { greater_than_or_equal_to: 0 }

  enum status: { pending: 0, accepted: 1, denied: 2, cancelled: 3, expired: 4, removed: 5 }

  private

  def is_expired
  end
end
