class ProjectJobCategory < ApplicationRecord
  belongs_to :project

  validates :job_category_id, uniqueness: { scope: :project_id }
end
