class TaskMailer < ApplicationMailer
  default from: 'notifications@colabora.com'

  def notify_leader_finish_task(task)
    @project = task.project
    @leader = @project.user
    @task = task
    mail(to: @leader.email, subject: 'A tarefa foi finalizada.')
  end
end
