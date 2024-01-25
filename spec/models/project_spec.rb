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
      another_user = create(:user, email: 'email@mail.com', cpf: '000.000.001-91')
      project = create(:project, user: leader)

      expect(project.user_roles.count).to eq 1
      expect(project.user_roles.last.role).to eq 'leader'
      expect(project.user_roles.last.user).not_to eq another_user
      expect(project.user_roles.last.user).to eq leader
    end
  end
end
