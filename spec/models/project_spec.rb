require 'rails_helper'

RSpec.describe Project, type: :model do
  context '#valid?' do
    it 'retorna false se Título for vazio' do
      user = create :user
      project = Project.new(user:, title: '')

      project.valid?

      expect(project.errors.include?(:title)).to be true
    end

    it 'retorna false se Descrição for vazio' do
      user = create :user
      project = Project.new(user:, description: '')

      project.valid?

      expect(project.errors.include?(:description)).to be true
    end

    it 'retorna false se Categoria for vazio' do
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
      project = create(:project)
      member = create(:user, cpf: '551.838.230-81', email: 'member@email.com')
      project.user_roles.create(user: member)

      expect(project.member?(member)).to be true
    end

    it 'retorna false se usuário não é colaborador do projeto' do
      project = create(:project)
      non_member = create(:user, cpf: '551.838.230-81', email: 'non_member@email.com')

      expect(project.member?(non_member)).to be false
    end
  end

  context '#leader?' do
    it 'retorna true se Usuário for lider' do
      user = create :user
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :leader)

      expect(project.leader?(user)).to eq true
    end

    it 'retorna false se Usuário for colaborador' do
      user = create :user
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :contributor)

      expect(project.leader?(user)).to eq false
    end

    it 'retorna false se Usuário for administrador' do
      user = create :user
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :admin)

      expect(project.leader?(user)).to eq false
    end
  end

  context '#set_leader_on_create' do
    it 'só o criador se torna líder' do
      create(:user, email: 'another_user@mail.com', cpf: '891.586.070-56')
      leader = create(:user, email: 'leader@email.com')
      project = create(:project, user: leader)
      contributor = create(:user, email: 'contributor@mail.com', cpf: '000.000.001-91')
      project.user_roles.create!(user: contributor, role: :contributor)

      expect(project.user_roles.count).to eq 2
      expect(project.user_roles.first.role).to eq 'leader'
      expect(project.user_roles.first.user).to eq leader
      expect(project.user_roles.last.role).to eq 'contributor'
      expect(project.user_roles.last.user).to eq contributor
    end
  end
end
