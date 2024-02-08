class MeetingMailer < ApplicationMailer
  default from: 'notifications@colabora.com'
  include MeetingHelper

  def notify_team_about_meeting
    @meeting = params[:meeting]
    @project = @meeting.project
    @participant = params[:participant]
    @address = link_to_address(@meeting.address)
    mail(to: @participant.email, subject: t '.subject')
  end
end
