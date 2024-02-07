class AddEmailToProposal < ActiveRecord::Migration[7.1]
  def change
    add_column :proposals, :email, :string, null: false
  end
end
