require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'create' do
    it 'cria um perfil associado ao usuário com campos vazios' do
      user = User.create!(cpf: '590.439.290-77', email: 'user@example.com', password: '654321')

      expect(user.profile).to be_present
      expect(user.profile.first_name).to be nil
      expect(user.profile.last_name).to be nil
      expect(user.profile.work_experience).to be nil
      expect(user.profile.education).to be nil
    end
  end

  describe '#valid?' do
    context 'presence' do
      it 'falso sem CPF' do
        user = User.new(cpf: '')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'falso sem e-mail' do
        user = User.new(email: '')

        expect(user.valid?).to be false
        expect(user.errors).to include :email
      end

      it 'falso sem senha' do
        user = User.new(password: '')

        expect(user.valid?).to be false
        expect(user.errors).to include :password
      end
    end

    context 'uniqueness' do
      it 'falso com CPF já utilizado' do
        create(:user, cpf: '568.064.040-65')
        user = User.new(cpf: '568.064.040-65')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'falso com e-mail já utilizado' do
        create(:user, email: 'usuario@email.com')
        user = User.new(email: 'usuario@email.com')

        expect(user.valid?).to be false
        expect(user.errors).to include :email
      end
    end

    context 'CPF válido' do
      it 'falso com CPF inválido com formatação' do
        user = User.new(cpf: '123.456.789-00')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'falso com CPF inválido sem formatação' do
        user = User.new(cpf: '12345678900')

        expect(user.valid?).to be false
        expect(user.errors).to include :cpf
      end

      it 'verdadeiro com CPF válido com formatação' do
        user = User.new(cpf: '125.445.890-51')

        user.valid?

        expect(user.errors).not_to include :cpf
      end

      it 'verdadeiro com CPF válido sem formatação' do
        user = User.new(cpf: '12544589051')

        user.valid?

        expect(user.errors).not_to include :cpf
      end
    end
  end

  describe '#can_edit?' do
    it 'Usuário edita reunião' do
      leader = create(:user)
      project = create(:project, user: leader)
      admin = create(:user, email: 'admin@email.com', cpf: '082.307.110-38')
      project.user_roles.create!(user: admin, role: :admin)
      contributor = create(:user, email: 'contributor@email.com', cpf: '891.586.070-56')
      project.user_roles.create!(user: contributor, role: :contributor)
      author = create(:user, email: 'author@email.com', cpf: '000.000.001-91')
      author_role = project.user_roles.create!(user: author, role: :contributor)

      meeting = create(:meeting, project:, user_role: author_role, title: 'Reunião do Lucas e Adoniran')

      expect(leader.can_edit?(meeting)).to eq true
      expect(admin.can_edit?(meeting)).to eq true
      expect(author.can_edit?(meeting)).to eq true
      expect(contributor.can_edit?(meeting)).to eq false
    end
  end

  context '#all_projects' do
    it 'retorna todos os projetos de um usuário' do
      user = create(:user)
      other_user = create(:user, cpf: '000.000.001-91')
      project_leader = create(:project, user:)
      project_contributor = create(:project, user: other_user)
      project_non_contributor = create(:project, user: other_user)
      create(:user_role, user:, project: project_contributor, role: :contributor)

      result = user.all_projects

      expect(result).to include project_leader
      expect(result).to include project_contributor
      expect(result).not_to include project_non_contributor
    end
    it 'retorna vazio se não tiver projetos' do
      user = create(:user)
      other_user = create(:user, cpf: '000.000.001-91')
      project_non_contributor = create(:project, user: other_user)

      result = user.all_projects

      expect(result).to eq []
      expect(result).not_to include project_non_contributor
    end
  end

  context '#my_projects' do
    it 'retorna todos os projetos de um usuário' do
      user = create(:user)
      other_user = create(:user, cpf: '000.000.001-91')
      project_leader = create(:project, user:)
      project_contributor = create(:project, user: other_user)
      project_non_contributor = create(:project, user: other_user)
      create(:user_role, user:, project: project_contributor, role: :contributor)

      result = user.my_projects

      expect(result).to include project_leader
      expect(result).not_to include project_contributor
      expect(result).not_to include project_non_contributor
    end
    it 'retorna vazio se não tiver projetos' do
      user = create(:user)
      other_user = create(:user, cpf: '000.000.001-91')
      project_contributor = create(:project, user: other_user)
      project_non_contributor = create(:project, user: other_user)
      create(:user_role, user:, project: project_contributor, role: :contributor)

      result = user.my_projects

      expect(result).to eq []
      expect(result).not_to include project_contributor
      expect(result).not_to include project_non_contributor
    end
  end

  context '#contributing_projects' do
    it 'retorna todos os projetos que é colaborador' do
      user = create(:user)
      other_user = create(:user, cpf: '000.000.001-91')
      project_leader = create(:project, user:)
      project_contributor = create(:project, user: other_user)
      project_non_contributor = create(:project, user: other_user)
      create(:user_role, user:, project: project_contributor, role: :contributor)

      result = user.contributing_projects

      expect(result).to include project_contributor
      expect(result).not_to include project_leader
      expect(result).not_to include project_non_contributor
    end

    it 'retorna vazio se não tiver projetos' do
      user = create(:user)
      other_user = create(:user, cpf: '000.000.001-91')
      project_leader = create(:project, user:)
      project_non_contributor = create(:project, user: other_user)

      result = user.contributing_projects

      expect(result).to eq []
      expect(result).not_to include project_leader
      expect(result).not_to include project_non_contributor
    end
  end
end
