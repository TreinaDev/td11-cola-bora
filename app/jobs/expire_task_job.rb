class ExpireTaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    return unless task.uninitialized? || task.in_progress?

    return unless task.due_date&.past?

    task.expired!
  end
end
