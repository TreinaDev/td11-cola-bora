class RemoveCategoryFromProjects < ActiveRecord::Migration[7.1]
  def change
    remove_column :projects, :category, :string
  end
end
