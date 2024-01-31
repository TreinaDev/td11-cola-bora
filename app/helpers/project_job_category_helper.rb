module ProjectJobCategoryHelper
  def fecth_per_job_category(job_category)
    unless job_category.blank?
      job_category.name
    else
      t('project_job_categories.not_found')
      # break if true
    end
  end
end
