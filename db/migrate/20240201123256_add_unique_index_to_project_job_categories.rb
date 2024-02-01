class AddUniqueIndexToProjectJobCategories < ActiveRecord::Migration[7.1]
  def change
    add_index :project_job_categories, [:project_id, :job_category_id], unique: true
  end
end
