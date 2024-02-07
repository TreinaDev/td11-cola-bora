class AddUserRoleToTask < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :user_role, null: false, foreign_key: true
  end
end
