class Invitation < ApplicationRecord
  belongs_to :project

  validate :pending_invitation_for_current_project, on: :create
  validates :expiration_days, numericality: { greater_than_or_equal_to: 0 }

  enum status: { pending: 0, accepted: 1, denied: 2, cancelled: 3, expired: 4, removed: 5 }

  private

  def pending_invitation_for_current_project
    return unless Invitation.exists?(project:, profile_id:, status: :pending)

    errors.add(:base, 'Esse usuário possui convite pendente')
  end
end
