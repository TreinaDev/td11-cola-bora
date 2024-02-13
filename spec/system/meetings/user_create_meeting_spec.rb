require 'rails_helper'

describe 'Usuário cria reunião' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, user:, title: 'Pousadaria')

    notify_participants_spy = spy(NotifyParticipantsJob)
    stub_const('NotifyParticipantsJob', notify_participants_spy)

    travel_to Time.zone.local(2023, 11, 24, 13, 55, 44)
    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Reuniões'
    click_on 'Nova Reunião'
    fill_in 'Título', with: 'Daily'
    fill_in 'datetime', with: '2024-11-24 14:00:00'
    fill_in 'Duração', with: '120'
    fill_in 'Endereço', with: 'https://meet.google.com'
    click_on 'Salvar'

    expect(Meeting.count).to eq 1
    expect(page).to have_content 'Reunião criada com sucesso.'
    expect(page).to have_content 'Reunião: Daily'
    expect(page).to have_content "Autor\n#{user.email}"
    expect(page).to have_content "Descrição\nSem descrição"
    expect(page).to have_content "Data e horário\n24/11/2024, 14:00"
    expect(page).to have_content "Duração\n2h"
    expect(page).to have_content "Endereço\nhttps://meet.google.com"
    expect(page).to have_link 'https://meet.google.com'

    expect(notify_participants_spy).to have_received(:perform_later).with(Meeting.last).once

    travel_back
  end

  it 'sem sucesso deixando os campos em branco' do
    user = create(:user)
    project = create(:project, user:, title: 'Pousadaria')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Reuniões'
    click_on 'Nova Reunião'
    fill_in 'Título', with: ''
    fill_in 'datetime', with: ''
    fill_in 'Duração', with: ''
    fill_in 'Endereço', with: ''
    click_on 'Salvar'

    expect(page).to have_content 'Não foi possível criar a Reunião.'
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Data e horário não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Duração não pode ficar em branco'
  end
end
