class AddJobCategoryIdToProjectJobCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :project_job_categories, :job_category_id, :integer, null: false
  end
end
