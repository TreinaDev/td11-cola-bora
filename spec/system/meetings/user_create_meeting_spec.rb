require 'rails_helper'

describe 'Usuário cria reunião' do
  it 'e deve estar autenticado' do
    visit new_project_meeting_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'com sucesso' do
    user = create(:user)
    project = create(:project, user:, title:'Pousadaria')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Reuniões'
    click_on 'Nova Reunião'
    fill_in 'Título', with: 'Daily'
    fill_in 'Descrição', with: ''
    fill_in 'Data', with: 2.days.from_now
    fill_in 'Horário', with: '14:00'
    fill_in 'Duração', with: '90'
    fill_in 'Endereço', with: 'https://meet.google.com'
    click_on 'Salvar'

    expect(page).to have_content 'Reunião criada com sucesso.'
    expect(page).to have_content "Título:\nDaily"
    expect(page).to have_content "Descrição:\nSem descrição"
    expect(page).to have_content "Quando:\n#{2.days.from_now} - 14:00"
    expect(page).to have_content "Duração:\n1:30h"
    expect(page).to have_content "Endereço:\nhttps://meet.google.com"
    expect(page).to have_link 'https://meet.google.com'
    expect(Meeting.count).to eq 1
  end
end
