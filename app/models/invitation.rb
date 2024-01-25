class Invitation < ApplicationRecord
  belongs_to :project

  validates :project_id, uniqueness: { scope: :profile_id }
  validates :expiration_days, numericality: { greater_than_or_equal_to: 0 }

  private

  def is_expired
  end
end
