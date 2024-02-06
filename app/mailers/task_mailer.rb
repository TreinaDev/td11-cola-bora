class TaskMailer < ApplicationMailer
  default from: 'notifications@colabora.com'

  def notify_leader_finish_task(project, task)
    @leader = project.user
    @project = project
    @task = task
    mail(to: @leader.email, subject: 'A tarefa foi finalizada.')
  end
end
