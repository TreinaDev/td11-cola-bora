class MeetingMailer < ApplicationMailer
  default from: 'notifications@colabora.com'
  include MeetingHelper

  def notify_team_about_meeting
    @meeting = params[:meeting]
    @participant = params[:participant]
    @project = @meeting.project
    @url = params[:url]
    @address = link_to_address(@meeting.address)
    mail(to: @participant.email, subject: 'Sua reunião já vai começar.')
  end
end
