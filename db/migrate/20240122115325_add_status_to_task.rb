class AddStatusToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :status, :integer, default: 0
  end
end
