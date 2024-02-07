class TaskMailer < ApplicationMailer
  default from: 'notifications@colabora.com'

  def notify_leader_finish_task(task, url)
    @project = task.project
    @leader = @project.user
    @task = task
    @url = url
    mail(to: @leader.email, subject: t('.subject'))
  end
end
