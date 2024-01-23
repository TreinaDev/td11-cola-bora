class AddAuthorAndAssignedToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :author, foreign_key: { to_table: :users }
    add_reference :tasks, :assigned, foreign_key: { to_table: :users }
  end
end
