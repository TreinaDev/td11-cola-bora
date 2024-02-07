require 'rails_helper'

describe 'Usuário cria reunião' do
  it 'e não é colaborador do projeto' do
    project = create(:project)
    other_user = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    other_project = create(:project, user: other_user)
    other_project_owner = create(:user_role, user: other_user, project: other_project)

    login_as other_project_owner.user, scope: :user
    post(project_meetings_path(project), params: { meeting: { title: 'Reunião do Rock in rio',
                                                              datetime: 2.days.from_now,
                                                              duration: 30,
                                                              address: 'https:google.com/aqui-em-casa' } })

    expect(response).to redirect_to root_path
    expect(Meeting.count).to eq 0
  end

  it 'e é colaborador do projeto' do
    project_owner = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    project = create(:project, user: project_owner)
    contributor = create(:user_role, project:)

    login_as contributor.user, scope: :user
    post(project_meetings_path(project), params: { meeting: { title: 'Reunião do Rock in rio',
                                                              datetime: 2.days.from_now,
                                                              duration: 30,
                                                              address: 'https://www.google.com/aqui-em-casa' } })

    meeting = Meeting.last
    expect(Meeting.count).to eq 1
    expect(response).to redirect_to project_meeting_path(project, meeting)
    expect(meeting.title).to eq 'Reunião do Rock in rio'
    expect(meeting.duration).to eq 30
    expect(meeting.address).to eq 'https://www.google.com/aqui-em-casa'
  end
end
