class Proposal < ApplicationRecord
  belongs_to :project

  validates :profile_id, :email, presence: true
  validates :profile_id, numericality: { greater_than_or_equal_to: 1 }
  validate :validate_participation, :validate_pending_proposal

  enum status: {
    pending: 1,
    accepted: 5,
    declined: 10,
    cancelled: 15
  }

  private

  def validate_participation
    participation = UserRole.joins(:user).find_by(user: { email: }, project_id:)&.active

    errors.add :base, I18n.t(:user_already_member_error) unless participation.nil?
  end

  def validate_pending_proposal
    proposal = Proposal.find_by(profile_id:, project_id:)
    return unless proposal&.pending?

    errors.add :base, I18n.t(:user_has_pending_proposals)
  end
end
