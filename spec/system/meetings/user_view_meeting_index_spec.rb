require 'rails_helper'

describe 'Usuário vê página de reuniões de um projeto' do
  it 'e existem reuniões cadastradas' do
    travel_to Time.zone.local(2024, 11, 24, 1, 4, 44)
    user = create(:user)
    project = create(:project, user:)
    create(:meeting, project:, title: 'Daily da segunda', datetime: Time.zone.local(2024, 11, 24, 14, 0, 0))
    create(:meeting, project:, title: 'Daily da tarde da segunda', datetime: Time.zone.local(2024, 11, 24, 14, 0, 0))
    create(:meeting, project:, title: 'Daily do feriado', datetime: Time.zone.local(2024, 11, 27, 14, 0, 0))
    create(:meeting, project:, title: 'Daily do final de semana', datetime: Time.zone.local(2024, 11, 30, 14, 0, 0))

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Reuniões'

    expect(page).to have_content 'Reuniões'
    expect(page).to have_content '24/11/2024'
    expect(page).to have_content '27/11/2024'
    expect(page).to have_content '30/11/2024'
    expect(page).to have_content 'Daily da segunda'
    expect(page).to have_content 'Daily da tarde da segunda'
    expect(page).to have_content 'Daily do feriado'
    expect(page).to have_content 'Daily do final de semana'
    travel_back
  end

  it 'e não existem reuniões' do
    user = create(:user)
    project = create(:project, user:)

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Reuniões'

    expect(page).to have_content 'Sem reuniões registradas'
  end

  it 'e completa o fluxo de index' do
    travel_to Time.zone.local(2024, 11, 24, 1, 4, 44)
    user = create(:user)
    project = create(:project, user:, title: 'Pousadaria')
    create(:meeting, project:, title: 'Daily da segunda', datetime: Time.zone.local(2024, 11, 24, 14, 0, 0))
    create(:meeting, project:, title: 'Daily do feriado', datetime: Time.zone.local(2024, 11, 27, 14, 0, 0))

    login_as user, scope: :user
    visit root_path
    click_on 'Projetos'
    click_on 'Pousadaria'
    click_on 'Reuniões'
    click_on 'Daily da segunda'
    click_on 'Voltar'

    expect(page).to have_current_path project_meetings_path(project)
    expect(page).to have_content 'Daily da segunda'
    expect(page).to have_content 'Daily do feriado'
    expect(page).to have_content '24/11/2024'
    expect(page).to have_content '27/11/2024'
    travel_back
  end

  it 'e não vê lista de participantes se não houver nenhum' do
    project = create :project
    user = create :user, cpf: '875.898.470-46'
    user_role = create :user_role, project:, user:, role: :contributor
    meeting = create(:meeting, project:, user_role:)

    login_as user
    visit project_meeting_path project, meeting

    expect(page).to have_content 'Adicione participantes para notificá-los'
    expect(page).not_to have_content 'Lista de Participantes'
  end
end
