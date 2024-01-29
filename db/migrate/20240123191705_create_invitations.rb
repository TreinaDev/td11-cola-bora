class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.date :due_date
      t.references :project, null: false, foreign_key: true
      t.integer :profile_id, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
