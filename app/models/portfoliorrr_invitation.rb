class PortfoliorrrInvitation
  def initialize(invitation)
    @profile_id = invitation.profile_id,
                  @project_title = invitation.project.title,
                  @project_description = invitation.project.description,
                  @project_category = invitation.project.category,
                  @colabora_invitation_id = invitation.id,
                  @message = invitation.message,
                  @expiration_date = invitation.expiration_date
  end

  def post_invitation
    invitation = Invitation.find(@colabora_invitation_id)
    headers = { 'Content-Type': 'application/json' }
    url = 'http://localhost:8000/invitations'
    response = Faraday.post(url, { 'data' => self }, headers)

    return invitation.cancelled! unless response.success?

    invitation.portfoliorrr_invitation_id = response.body[:data][:id]
    invitation.pending!
    invitation.save
  rescue Faraday::ConnectionFailed
    invitation.cancelled!
  end
end
