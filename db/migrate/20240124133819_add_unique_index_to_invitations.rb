class AddUniqueIndexToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_index :invitations, [:project_id, :profile_id], unique: true
  end
end
