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
    conn = Faraday.new(url: 'http://localhost:3000')

    response = conn.post('/invitations.json') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = JSON.generate(self)
    end
  rescue Faraday::ConnectionFailed; end
end
