class AddActiveToUserRoles < ActiveRecord::Migration[7.1]
  def change
    add_column :user_roles, :active, :boolean, default: true
  end
end
