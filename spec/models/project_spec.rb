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
      user = create :user
      project = create(:project, user:)

      expect(project.user_roles.count).to eq 1
      expect(project.user_roles.last.role).to eq 'leader'
    end
  end

  describe '#member?' do
    it 'retorna true se usuário é colaborador do projeto' do
      project = build(:project)
      member = build(:user, cpf: '551.838.230-81', email: 'member@email.com')
      project.user_roles.build(user: member)

      expect(project.member?(member)).to be true
    end

    it 'retorna false se usuário não é colaborador do projeto' do
      project = build(:project)
      non_member = build(:user, cpf: '551.838.230-81', email: 'non_member@email.com')

      expect(project.member?(non_member)).to be false
    end
  end
end
