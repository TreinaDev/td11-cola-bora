require 'rails_helper'

describe 'Colaborador filtra lista de membros' do
  it 'por admins' do
    leader = create(:user, cpf: '515.185.620-00', email: 'leader@email.com')
    leader.profile.update!(first_name: 'PH', last_name: 'Meneses')
    project = create(:project, user: leader)
    admin1 = create(:user, cpf: '485.836.250-77', email: 'admin1@email.com')
    admin1.profile.update!(first_name: 'João', last_name: 'Silva')
    admin2 = create(:user, cpf: '996.596.510-23', email: 'admin2@email.com')
    admin2.profile.update!(first_name: 'Maria', last_name: 'Costa')
    contributor = create(:user, cpf: '979.612.040-24', email: 'colaborador@email.com')
    contributor.profile.update!(first_name: 'Mateus', last_name: 'Cavedini')
    project.user_roles.create([{ user: admin1, role: :admin },
                               { user: admin2, role: :admin },
                               { user: contributor }])

    login_as contributor, scope: :user
    visit members_project_path(project)
    select 'Administradores', from: 'Filtro'
    click_on 'Filtrar'

    within 'table' do
      expect(page).to have_content 'João Silva'
      expect(page).to have_content 'Maria Costa'
      expect(page).to have_content 'admin1@email.com'
      expect(page).to have_content 'admin2@email.com'
      expect(page).to have_content 'Administrador', count: 2
      expect(page).not_to have_content 'PH Meneses'
      expect(page).not_to have_content 'leader@email.com'
      expect(page).not_to have_content 'Mateus Cavedini'
      expect(page).not_to have_content 'colaborador@email.com'
      expect(page).not_to have_content 'Líder'
      expect(page).not_to have_content 'Colaborador'
    end
  end

  it 'por colaboradores' do
    leader = create(:user, cpf: '515.185.620-00', email: 'leader@email.com')
    leader.profile.update!(first_name: 'PH', last_name: 'Meneses')
    project = create(:project, user: leader)
    admin = create(:user, cpf: '485.836.250-77', email: 'admin@email.com')
    admin.profile.update!(first_name: 'João', last_name: 'Silva')
    contributor = create(:user, cpf: '979.612.040-24', email: 'colaborador@email.com')
    contributor.profile.update!(first_name: 'Mateus', last_name: 'Cavedini')
    contributor2 = create(:user, cpf: '996.596.510-23', email: 'colaborador2@email.com')
    contributor2.profile.update!(first_name: 'Maria', last_name: 'Costa')
    project.user_roles.create([{ user: admin, role: :admin },
                               { user: contributor },
                               { user: contributor2 }])

    login_as admin, scope: :user
    visit members_project_path project
    select 'Colaboradores', from: 'Filtro'
    click_on 'Filtrar'

    within 'table' do
      expect(page).to have_content 'Mateus Cavedini'
      expect(page).to have_content 'colaborador@email.com'
      expect(page).to have_content 'Maria Costa'
      expect(page).to have_content 'colaborador2@email.com'
      expect(page).to have_content 'Colaborador', count: 2
      expect(page).not_to have_content 'João Silva'
      expect(page).not_to have_content 'admin@email.com'
      expect(page).not_to have_content 'PH Meneses'
      expect(page).not_to have_content 'leader@email.com'
      expect(page).not_to have_content 'Líder'
      expect(page).not_to have_content 'Administrador'
    end
  end

  it 'por líder' do
    leader = create(:user, cpf: '515.185.620-00', email: 'leader@email.com')
    leader.profile.update!(first_name: 'PH', last_name: 'Meneses')
    project = create(:project, user: leader)
    admin = create(:user, cpf: '485.836.250-77', email: 'admin@email.com')
    admin.profile.update!(first_name: 'João', last_name: 'Silva')
    contributor = create(:user, cpf: '979.612.040-24', email: 'colaborador@email.com')
    contributor.profile.update!(first_name: 'Mateus', last_name: 'Cavedini')
    contributor2 = create(:user, cpf: '996.596.510-23', email: 'colaborador2@email.com')
    contributor2.profile.update!(first_name: 'Maria', last_name: 'Costa')
    project.user_roles.create([{ user: admin, role: :admin },
                               { user: contributor },
                               { user: contributor2 }])

    login_as contributor, scope: :user
    visit members_project_path project
    select 'Líder', from: 'Filtro'
    click_on 'Filtrar'

    within 'table' do
      expect(page).to have_content 'PH Meneses'
      expect(page).to have_content 'leader@email.com'
      expect(page).to have_content 'Líder'
      expect(page).not_to have_content 'João Silva'
      expect(page).not_to have_content 'admin@email.com'
      expect(page).not_to have_content 'Mateus Cavedini'
      expect(page).not_to have_content 'colaborador@email.com'
      expect(page).not_to have_content 'Maria Costa'
      expect(page).not_to have_content 'colaborador2@email.com'
      expect(page).not_to have_content 'Colaborador'
      expect(page).not_to have_content 'Administrador'
    end
  end

  it 'e retorna para todos os membros'
end
