class ExpireTaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    return unless task.uninitialized? || task.in_progress?

    return unless task.due_date && task.due_date <= Time.zone.today.to_date

    task.expired!
  end
end
