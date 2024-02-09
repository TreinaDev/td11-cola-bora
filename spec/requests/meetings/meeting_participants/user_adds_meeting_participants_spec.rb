require 'rails_helper'

describe 'Usuário adiciona participantes na reunião' do
  it 'e não está autenticado' do
    leader = create(:user)
    project = create(:project, user: leader)
    author = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    author_role = project.user_roles.create!(user: author)
    meeting = create(:meeting, project:, user_role: author_role, title: 'Reunião blabla')

    post project_meeting_meeting_participants_path project, meeting

    expect(response).to redirect_to new_user_session_path
  end

  context 'e não é o autor' do
    it 'mas é líder' do
      leader = create :user
      project = create :project, user: leader
      author = create :user, cpf: '000.000.001-91'
      author_role = create :user_role, project:, user: author, role: :contributor
      meeting = create :meeting, project:, user_role: author_role
      params = { meeting_participant: { meeting_participant_ids: [author.id, leader.id] } }

      login_as leader
      post(project_meeting_meeting_participants_path(project, meeting), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
    end

    it 'mas é admin' do
      project = create :project
      author = create :user, cpf: '000.000.001-91'
      author_role = create :user_role, project:, user: author, role: :contributor
      admin = create :user, cpf: '279.143.900-54'
      create :user_role, project:, user: admin, role: :admin
      meeting = create :meeting, project:, user_role: author_role
      params = { meeting_participant: { meeting_participant_ids: [author.id, admin.id] } }

      login_as admin
      post(project_meeting_meeting_participants_path(project, meeting), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
    end

    it 'mas é colaborador' do
      project = create :project
      author = create :user, cpf: '000.000.001-91'
      author_role = create :user_role, project:, user: author, role: :contributor
      contributor = create :user, cpf: '279.143.900-54'
      create :user_role, project:, user: contributor, role: :contributor
      meeting = create :meeting, project:, user_role: author_role
      params = { meeting_participant: { meeting_participant_ids: [author.id, contributor.id] } }

      login_as contributor
      post(project_meeting_meeting_participants_path(project, meeting), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
    end

    it 'e não é membro do projeto' do
      leader = create :user
      project = create :project, user: leader
      author = create :user, cpf: '000.000.001-91'
      author_role = create :user_role, project:, user: author, role: :contributor
      non_member = create :user, cpf: '279.143.900-54'
      meeting = create :meeting, project:, user_role: author_role
      params = { meeting_participant: { meeting_participant_ids: [author.id, leader.id] } }

      login_as non_member
      post(project_meeting_meeting_participants_path(project, meeting), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
    end
  end

  it 'com user_role_id inexistente' do
    project = create :project
    author = create :user, cpf: '000.000.001-91'
    author_role = create :user_role, project:, user: author, role: :contributor
    meeting = create :meeting, project:, user_role: author_role
    params = { meeting_participant: { meeting_participant_ids: [author.id, 999] } }

    login_as author
    post(project_meeting_meeting_participants_path(project, meeting), params:)

    expect(response).to have_http_status :unprocessable_entity
    expect(MeetingParticipant.count).to eq 0
  end
end
