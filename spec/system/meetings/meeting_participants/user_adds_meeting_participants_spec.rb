require 'rails_helper'

describe 'Usuário adiciona participantes a reunião' do
  it 'com sucesso' do
    leader = create :user, email: 'leader@email.com'
    project = create :project, user: leader
    author = create :user, cpf: '607.149.470-24', email: 'author@email.com'
    author_role = create :user_role, project:, user: author, role: :contributor
    future_participant1 = create :user, cpf: '850.265.590-69', email: 'participant1@email.com'
    create :user_role, project:, user: future_participant1, role: :admin
    future_participant2 = create :user, cpf: '359.739.000-53', email: 'participant2@email.com'
    create :user_role, project:, user: future_participant2, role: :contributor
    not_invited = create :user, cpf: '781.720.590-60', email: 'not_invited@email.com'
    create :user_role, project:, user: not_invited, role: :contributor
    meeting = create :meeting, project:, title: 'Reunião Semanal', user_role: author_role

    login_as author
    visit project_meeting_path project, meeting
    click_on 'Adicionar Participantes'
    check 'leader'
    check 'participant1'
    check 'participant2'
    click_on 'Adicionar'

    expect(page).to have_current_path project_meeting_path project, meeting
    expect(page).to have_content 'Lista de Participantes'
    expect(page).to have_content 'leader'
    expect(page).to have_content 'participant1'
    expect(page).to have_content 'participant2'
    expect(page).not_to have_content 'not_invited'
  end

  xit 'e não vê usuários que não fazem parte do projeto'
  xit 'e ninguém é adicionado'
  xit 'somente autor adiciona participantes'
end
