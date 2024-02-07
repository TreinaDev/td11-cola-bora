class RemoveUserFromTask < ActiveRecord::Migration[7.1]
  def change
    remove_reference :tasks, :author, foreign_key: { to_table: :users }
  end
end