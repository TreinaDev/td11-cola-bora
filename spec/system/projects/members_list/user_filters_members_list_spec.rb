require 'rails_helper'

describe 'Colaborador filtra lista de membros' do
  context 'por admins' do
    it 'e vê os administradores do projeto' do
      leader = create :user, cpf: '515.185.620-00', email: 'leader@email.com'
      leader.profile.update! first_name: 'PH', last_name: 'Meneses'
      project = create :project, user: leader
      admin1 = create :user, cpf: '485.836.250-77', email: 'admin1@email.com'
      admin1.profile.update! first_name: 'João', last_name: 'Silva'
      admin2 = create :user, cpf: '996.596.510-23', email: 'admin2@email.com'
      admin2.profile.update! first_name: 'Maria', last_name: 'Costa'
      contributor = create :user, cpf: '979.612.040-24', email: 'contribuidor@email.com'
      contributor.profile.update! first_name: 'Mateus', last_name: 'Cavedini'
      project.user_roles.create([{ user: admin1, role: :admin },
                                 { user: admin2, role: :admin },
                                 { user: contributor }])

      login_as contributor, scope: :user
      visit members_project_path project
      select 'Administradores', from: :query
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
        expect(page).not_to have_content 'contribuidor@email.com'
        expect(page).not_to have_content 'Líder'
        expect(page).not_to have_content 'Contribuidor'
        expect(page).not_to have_content 'Nenhum resultado encontrado'
      end
      within '#filter-form' do
        expect(page).to have_select :query, selected: 'Administradores'
      end
    end

    it 'e não existem administradores no projeto' do
      leader = create :user
      project = create :project, user: leader
      contributor = create :user, cpf: '979.612.040-24'
      project.user_roles.create!({ user: contributor })

      login_as contributor, scope: :user
      visit members_project_path(project)
      select 'Administradores', from: :query
      click_on 'Filtrar'

      within 'table' do
        expect(page).to have_content 'Nenhum resultado encontrado'
      end
    end
  end

  context 'por contribuidores' do
    it 'e vê os contribuidores do projeto' do
      leader = create :user, cpf: '515.185.620-00', email: 'leader@email.com'
      leader.profile.update! first_name: 'PH', last_name: 'Meneses'
      project = create :project, user: leader
      admin = create :user, cpf: '485.836.250-77', email: 'admin@email.com'
      admin.profile.update! first_name: 'João', last_name: 'Silva'
      contributor = create :user, cpf: '979.612.040-24', email: 'contribuidor@email.com'
      contributor.profile.update! first_name: 'Mateus', last_name: 'Cavedini'
      contributor2 = create :user, cpf: '996.596.510-23', email: 'contribuidor2@email.com'
      contributor2.profile.update! first_name: 'Maria', last_name: 'Costa'
      project.user_roles.create([{ user: admin, role: :admin },
                                 { user: contributor },
                                 { user: contributor2 }])

      login_as admin, scope: :user
      visit members_project_path project
      select 'Contribuidores', from: :query
      click_on 'Filtrar'

      within 'table' do
        expect(page).to have_content 'Mateus Cavedini'
        expect(page).to have_content 'contribuidor@email.com'
        expect(page).to have_content 'Maria Costa'
        expect(page).to have_content 'contribuidor2@email.com'
        expect(page).to have_content 'Contribuidor', count: 2
        expect(page).not_to have_content 'João Silva'
        expect(page).not_to have_content 'admin@email.com'
        expect(page).not_to have_content 'PH Meneses'
        expect(page).not_to have_content 'leader@email.com'
        expect(page).not_to have_content 'Líder'
        expect(page).not_to have_content 'Administrador'
        expect(page).not_to have_content 'Nenhum resultado encontrado'
      end
      within '#filter-form' do
        expect(page).to have_select :query, selected: 'Contribuidores'
      end
    end

    it 'e não existem contribuidores no projeto' do
      leader = create :user
      project = create :project, user: leader
      admin = create :user, cpf: '979.612.040-24'
      project.user_roles.create!({ user: admin, role: :admin })

      login_as admin, scope: :user
      visit members_project_path(project)
      select 'Contribuidores', from: :query
      click_on 'Filtrar'

      within 'table' do
        expect(page).to have_content 'Nenhum resultado encontrado'
      end
    end
  end

  it 'por líder' do
    leader = create :user, cpf: '515.185.620-00', email: 'leader@email.com'
    leader.profile.update! first_name: 'PH', last_name: 'Meneses'
    project = create :project, user: leader
    admin = create :user, cpf: '485.836.250-77', email: 'admin@email.com'
    admin.profile.update! first_name: 'João', last_name: 'Silva'
    contributor = create :user, cpf: '979.612.040-24', email: 'contribuidor@email.com'
    contributor.profile.update! first_name: 'Mateus', last_name: 'Cavedini'
    contributor2 = create :user, cpf: '996.596.510-23', email: 'contribuidor2@email.com'
    contributor2.profile.update! first_name: 'Maria', last_name: 'Costa'
    project.user_roles.create([{ user: admin, role: :admin },
                               { user: contributor },
                               { user: contributor2 }])

    login_as contributor, scope: :user
    visit members_project_path project
    select 'Líder', from: :query
    click_on 'Filtrar'

    within 'table' do
      expect(page).to have_content 'PH Meneses'
      expect(page).to have_content 'leader@email.com'
      expect(page).to have_content 'Líder'
      expect(page).not_to have_content 'João Silva'
      expect(page).not_to have_content 'admin@email.com'
      expect(page).not_to have_content 'Mateus Cavedini'
      expect(page).not_to have_content 'contribuidor@email.com'
      expect(page).not_to have_content 'Maria Costa'
      expect(page).not_to have_content 'contribuidor2@email.com'
      expect(page).not_to have_content 'Contribuidor'
      expect(page).not_to have_content 'Administrador'
    end
    within '#filter-form' do
      expect(page).to have_select :query, selected: 'Líder'
    end
  end

  it 'e filtra por todos os membros' do
    leader = create :user, cpf: '515.185.620-00', email: 'leader@email.com'
    leader.profile.update! first_name: 'PH', last_name: 'Meneses'
    project = create :project, user: leader
    admin1 = create :user, cpf: '485.836.250-77', email: 'admin1@email.com'
    admin1.profile.update! first_name: 'João', last_name: 'Silva'
    admin2 = create :user, cpf: '996.596.510-23', email: 'admin2@email.com'
    admin2.profile.update! first_name: 'Maria', last_name: 'Costa'
    contributor = create :user, cpf: '979.612.040-24', email: 'contribuidor@email.com'
    contributor.profile.update! first_name: 'Mateus', last_name: 'Cavedini'
    project.user_roles.create([{ user: admin1, role: :admin },
                               { user: admin2, role: :admin },
                               { user: contributor }])

    login_as contributor, scope: :user
    visit members_project_path project
    select 'Administradores', from: :query
    click_on 'Filtrar'
    select 'Todos', from: :query
    click_on 'Filtrar'

    within 'table' do
      expect(page).to have_content 'PH Meneses'
      expect(page).to have_content 'leader@email.com'
      expect(page).to have_content 'João Silva'
      expect(page).to have_content 'admin1@email.com'
      expect(page).to have_content 'Maria Costa'
      expect(page).to have_content 'admin2@email.com'
      expect(page).to have_content 'Mateus Cavedini'
      expect(page).to have_content 'contribuidor@email.com'
      expect(page).to have_content 'Líder'
      expect(page).to have_content 'Administrador', count: 2
      expect(page).to have_content 'Contribuidor'
    end
    within '#filter-form' do
      expect(page).to have_select :query, selected: 'Todos'
    end
  end
end
