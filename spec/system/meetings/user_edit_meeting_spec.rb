require 'rails_helper'

describe 'Usuário edita Reunião' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, user:)
    meeting = create(:meeting, project:)

    login_as(user, scope: :user)
    visit project_meeting_path(project, meeting)
    click_on 'Editar Reunião'
    fill_in 'Título', with: 'Reunião correta'
    fill_in 'Descrição', with: 'Essa edição conserta a Reunião'
    fill_in 'Duração', with: '90'
    fill_in 'Endereço', with: 'https://meet.google.com/shde1i9'
    click_on 'Salvar'

    expect(page).to have_content('Reunião editada com sucesso')
    expect(page).to have_content('Reunião: Reunião correta')
    expect(page).to have_content("Descrição\nEssa edição conserta a Reunião")
    expect(page).to have_content("Duração\n1h30")
    expect(page).to have_content("Endereço\nhttps://meet.google.com/shde1i9")
  end

  it 'e falha porque um campo obrigatório ficou em branco' do
    user = create(:user)
    project = create(:project, user:)
    meeting = create(:meeting, project:)

    login_as(user, scope: :user)
    visit project_meeting_path(project, meeting)
    click_on 'Editar Reunião'
    fill_in 'Título', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível editar a Reunião.')
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Editar Reunião')
    expect(page).to have_field('Título')
    expect(page).to have_field('Descrição')
  end
end
