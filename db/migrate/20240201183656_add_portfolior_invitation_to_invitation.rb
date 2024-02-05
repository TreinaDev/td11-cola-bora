class AddPortfoliorInvitationToInvitation < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :portfoliorrr_invitation_id, :integer
  end
end
