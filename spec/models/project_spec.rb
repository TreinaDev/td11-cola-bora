require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'Campo vazio' do
    it 'Título do projeto vazio' do
      user = create :user
      project = Project.new(user:, title: '')

      project.valid?

      expect(project.errors.include?(:title)).to be true
    end

    it 'Descrição vazia' do
      user = create :user
      project = Project.new(user:, description: '')

      project.valid?

      expect(project.errors.include?(:description)).to be true
    end

    it 'Categoria vazia' do
      user = create :user
      project = Project.new(user:, category: '')

      project.valid?

      expect(project.errors.include?(:category)).to be true
    end
  end

  describe 'Autor do projeto se torna líder' do
    it 'com sucesso' do
      leader = create(:user, email: 'leader@email.com')
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@mail.com', cpf: '000.000.001-91')
      project.user_roles.create!(user: contributor, role: :contributor)
      another_user = create(:user, email: 'another_user@mail.com', cpf: '891.586.070-56')

      expect(project.user_roles.count).to eq 2
      expect(project.user_roles.first.role).to eq 'leader'
      expect(project.user_roles.first.user).to eq leader
      expect(project.user_roles.last.role).to eq 'contributor'
      expect(project.user_roles.last.user).to eq contributor
    end
  end
end
