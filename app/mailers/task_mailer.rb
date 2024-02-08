class TaskMailer < ApplicationMailer
  default from: 'notifications@colabora.com'

  def notify_leader_finish_task
    @task = params[:task]
    @project = @task.project
    @leader = @project.user
    mail(to: @leader.email, subject: t('.subject'))
  end
end
