require 'rails_helper'

describe 'Usuário edita reunião' do
  it 'e é contribuinte autor da reunião' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião blabla')

    login_as contributor, scope: :user
    patch(project_meeting_path(project, meeting), params: { meeting: { title: 'Reunião do Rock in rio' } })

    expect(meeting.title).to eq 'Reunião do Rock in rio'
    expect(response).to redirect_to project_meeting_path(project, meeting)
  end

  it 'e é contribuinte do projeto não autor da reunião' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: contributor, role: :contributor)
    meeting = create(:meeting, project:, user_role: leader.user_roles.first, title: 'Reunião blabla')

    login_as contributor, scope: :user
    patch(project_meeting_path(project, meeting), params: { meeting: { title: 'Reunião do Rock in rio' } })

    expect(meeting.title).to eq 'Reunião blabla'
    expect(response).to redirect_to project_meeting_path(project, meeting)
  end

  it 'e é um líder não autor da reunião' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    meeting = create(:meeting, project:, user_role: contributor_role, title: 'Reunião blabla')

    login_as leader, scope: :user
    patch(project_meeting_path(project, meeting), params: { meeting: { title: 'Reunião do Rock in rio' } })

    expect(meeting.title).to eq 'Reunião do Rock in rio'
    expect(response).to redirect_to project_meeting_path(project, meeting)
  end

  it 'e é um administrador não autor da reunião' do
    leader = create(:user)
    project = create(:project, user: leader)
    admin = create(:user, email: 'admin@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: admin, role: :admin)
    meeting = create(:meeting, project:, user_role: leader.user_roles.first, title: 'Reunião blabla')

    login_as admin, scope: :user
    patch(project_meeting_path(project, meeting), params: { meeting: { title: 'Reunião do Rock in rio' } })

    expect(meeting.title).to eq 'Reunião do Rock in rio'
    expect(response).to redirect_to project_meeting_path(project, meeting)
  end
end
