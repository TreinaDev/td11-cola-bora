class AddExpirationDaysToInvitation < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :expiration_days, :integer
  end
end
