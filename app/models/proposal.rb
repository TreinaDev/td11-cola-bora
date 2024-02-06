class Proposal < ApplicationRecord
  belongs_to :project

  validates :profile_id, presence: true
  validates :profile_id, numericality: { greater_than_or_equal_to: 1 }
  validate :validate_participation

  enum status: {
    pending: 1,
    accepted: 5,
    declined: 10,
    cancelled: 15
  }

  private

  def validate_participation
    invitation = Invitation.find_by(profile_id:, project_id:, status: :accepted)

    return false if invitation.blank?

    project = Project.find_by(id: project_id)
    user_email = invitation.profile_email
    user = User.find_by(email: user_email)
    user_role = UserRole.find_by(user:, project:, active: true)

    errors.add(:base, 'Usuário já faz parte deste projeto') unless user_role.nil?
  end
end
