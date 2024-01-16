class CreateUserRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.integer :role, default: 1

      t.timestamps
    end
  end
end
