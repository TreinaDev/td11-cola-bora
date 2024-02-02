class CreateProjectJobCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :project_job_categories do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
