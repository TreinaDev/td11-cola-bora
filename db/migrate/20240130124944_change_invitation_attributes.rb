class ChangeInvitationAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :expiration_date, :date
    add_column :invitations, :profile_email, :string
    add_column :invitations, :message, :text
    remove_column :invitations, :expiration_days
  end
end
