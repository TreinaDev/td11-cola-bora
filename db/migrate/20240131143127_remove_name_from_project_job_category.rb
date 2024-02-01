class RemoveNameFromProjectJobCategory < ActiveRecord::Migration[7.1]
  def change
    remove_column :project_job_categories, :name, :string
  end
end
