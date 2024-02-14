class PostInvitationJob < ApplicationJob
  queue_as :default
  retry_on StandardError

  def perform(invitation)
    response = InvitationService::PortfoliorrrPost.send invitation

    raise StandardError unless response
  end
end
