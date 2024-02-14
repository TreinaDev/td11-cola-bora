class CreateInvitationJob < ApplicationJob
  def perform(invitation)
    InvitationService::PortfoliorrrPost.send invitation
  end
end
