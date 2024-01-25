class RemoveUniqueIndexFromInvitations < ActiveRecord::Migration[7.1]
  def change
    remove_index :invitations, name: 'index_invitations_on_project_id_and_profile_id'
  end
end
