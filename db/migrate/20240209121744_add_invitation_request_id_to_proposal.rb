class AddInvitationRequestIdToProposal < ActiveRecord::Migration[7.1]
  def change
    add_column :proposals, :portfoliorrr_proposal_id, :integer, null: false
  end
end
