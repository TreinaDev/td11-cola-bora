require 'rails_helper'

RSpec.describe ProjectJobCategory, type: :model do
  context '#valid' do
    it 'projeto não pode ter categoria de trabalho repetida' do
      project = create(:project)
      job_categories = [JobCategory.new(id: 1, name: 'Desenvolvedor')]
      allow(JobCategory).to receive(:all).and_return(job_categories)
      allow(JobCategory).to receive(:find).and_return(job_categories[0])
      create(:project_job_category, project:, job_category_id: 1)
      project_job_category = build(:project_job_category, project:, job_category_id: 1)

      job_category_repeat = project_job_category.valid?

      expect(job_category_repeat).to eq false
      expect(project_job_category.errors.full_messages).to include 'Categoria de trabalho já está em uso'
    end
  end
end
