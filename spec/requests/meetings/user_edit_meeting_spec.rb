require 'rails_helper'

describe 'Usuário edita reunião' do
  it 'e é autor da reunião' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião blabla')

    login_as contributor, scope: :user
    patch(meeting_path(meeting), params: { meeting: { title: 'Reunião do Rock in rio' } })

    expect(meeting.title).not_to eq 'Reunião do Rock in rio'
    expect(response).to redirect_to meeting_path(meeting)
  end

  it 'e é um colaborador do projeto não autor da reunião' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: contributor)
    meeting = create(:meeting, project:, user_role: leader.user_roles.first, title: 'Reunião blabla')

    login_as contributor, scope: :user
    patch(meeting_path(meeting), params: { meeting: { title: 'Reunião do Rock in rio' } })

    expect(meeting.title).to eq 'Reunião blabla'
    expect(response).to redirect_to meeting_path(meeting)
  end
end
