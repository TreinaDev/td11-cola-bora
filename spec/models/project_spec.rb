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

    it 'retorna false se Usuário for líder de outro projeto' do
      leader = create :user
      project = create :project, user: leader
      other_leader = create :user, cpf: '149.759.780-32'
      create :project, user: other_leader, title: 'Outro Projeto'

      expect(project.leader?(other_leader)).to eq false
    end
  end

  context '#member?' do
    it 'retorna true se Usuário tem vínculo com o projeto' do
      user = create :user, cpf: '149.759.780-32'
      project = create(:project)
      create :user_role, user:, project:, role: :contributor

      expect(project.member?(user)).to eq true
    end

    it 'retorna false se Usuário não tem vínculo com o projeto' do
      user = create :user, cpf: '149.759.780-32'
      project = create(:project)

      expect(project.member?(user)).to eq false
    end

    it 'retorna false se usuário é membro apenas de outro projeto' do
      leader = create :user
      project = create :project, user: leader
      other_project = create :project, user: leader, title: 'Outro Projeto'
      user = create :user, cpf: '149.759.780-32'
      create :user_role, project: other_project, user:, role: :contributor

      expect(project.member?(user)).to eq false
    end
  end

  context '#set_leader_on_create' do
    it 'só o criador se torna líder' do
      create :user, email: 'another_user@mail.com', cpf: '891.586.070-56'
      leader = create :user, email: 'leader@email.com'
      project = create :project, user: leader
      contributor = create :user, email: 'contributor@mail.com', cpf: '000.000.001-91'
      project.user_roles.create! user: contributor, role: :contributor

      expect(project.user_roles.count).to eq 2
      expect(project.user_roles.first.role).to eq 'leader'
      expect(project.user_roles.first.user).to eq leader
      expect(project.user_roles.last.role).to eq 'contributor'
      expect(project.user_roles.last.user).to eq contributor
    end
  end

  context '#member_roles' do
    it 'retorna um array com o user_role do líder do projeto' do
      leader = create :user
      project = create :project, user: leader
      leader_role = UserRole.last

      expect(project.member_roles(:leader)).to eq [leader_role]
      expect(project.member_roles(:leader).first.user).to eq leader
    end

    it 'retorna os administradores do projeto como UserRole' do
      leader = create :user
      admin1 = create :user, cpf: '355.203.830-22'
      admin2 = create :user, cpf: '634.329.380-98'
      contributor = create :user, cpf: '440.882.180-27'
      project = create :project, user: leader
      admin_1_role = create :user_role, project:, user: admin1, role: :admin
      admin_2_role = create :user_role, project:, user: admin2, role: :admin
      create :user_role, user: contributor, project:, role: :contributor

      expect(project.member_roles(:admin).count).to eq 2
      expect(project.member_roles(:admin)).to eq [admin_1_role, admin_2_role]
      expect(project.member_roles(:admin).first.user).to eq admin1
      expect(project.member_roles(:admin).last.user).to eq admin2
    end

    it 'retorna um array vazio se não houver admins no projeto' do
      project = create :project

      expect(project.member_roles(:admin)).to eq []
    end

    it 'retorna os usuários com papel de colaborador' do
      leader = create :user
      project = create :project, user: leader
      admin = create :user, cpf: '355.203.830-22'
      contributor1 = create :user, cpf: '634.329.380-98'
      contributor2 = create :user, cpf: '440.882.180-27'
      create :user_role, project:, user: admin, role: :admin
      contributor_1_role = create :user_role, project:, user: contributor1
      contributor_2_role = create :user_role, project:, user: contributor2

      expect(project.member_roles(:contributor).count).to eq 2
      expect(project.member_roles(:contributor)).to eq [contributor_1_role, contributor_2_role]
      expect(project.member_roles(:contributor).first.user).to eq contributor1
      expect(project.member_roles(:contributor).last.user).to eq contributor2
    end

    it 'retorna um array vazio se não houver colaboradores no projeto' do
      project = create :project

      expect(project.member_roles(:contributor)).to eq []
    end

    it 'retorna nil com papel inexistente' do
      project = create :project
      admin = create :user, cpf: '355.203.830-22'
      create :user_role, project:, user: admin, role: :admin

      expect(project.member_roles(:foo)).to eq nil
    end
  end
end
