class CreateProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :proposals do |t|
      t.references :project, null: false, foreign_key: true
      t.integer :status, default: 1
      t.text :message
      t.integer :profile_id, null: false

      t.timestamps
    end
  end
end
