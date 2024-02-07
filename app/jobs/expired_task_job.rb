class ExpiredTaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    task.expired! if task.uninitialized? || task.in_progress?
  end
end
