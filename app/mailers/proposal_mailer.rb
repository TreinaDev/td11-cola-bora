class ProposalMailer < ApplicationMailer
  default from: 'notification@colabora.com'

  def notify_leader
    @proposal = params[:proposal]
    @project = @proposal.project
    @leader = @project.user

    mail to: @leader.email, subject: t('.subject')
  end
end
