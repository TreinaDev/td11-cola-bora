class ChangeDueDateInInvitations < ActiveRecord::Migration[7.1]
  def change
    rename_column :invitations, :due_date, :expiration_days
    change_column :invitations, :expiration_days, :integer
  end
end
