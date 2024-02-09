require 'rails_helper'

describe 'Usuário acessa formulário para adicionar participantes da reunião' do
  it 'e não está autenticado' do
    project = create :project
    author = create :user, cpf: '000.000.001-91'
    author_role = create :user_role, project:, user: author, role: :contributor
    meeting = create :meeting, project:, user_role: author_role

    get new_project_meeting_meeting_participant_path project, meeting

    expect(response).to redirect_to new_user_session_path
  end

  it 'mas não é o autor' do
    leader = create :user
    project = create :project, user: leader
    author = create :user, cpf: '000.000.001-91'
    author_role = create :user_role, project:, user: author, role: :contributor
    meeting = create :meeting, project:, user_role: author_role

    login_as leader
    get new_project_meeting_meeting_participant_path project, meeting

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
  end

  it 'autenticado, mas não faz parte do projeto' do
    project = create :project
    author = create :user, cpf: '000.000.001-91'
    author_role = create :user_role, project:, user: author, role: :contributor
    non_member = create :user, cpf: '279.143.900-54'
    meeting = create :meeting, project:, user_role: author_role

    login_as non_member
    get new_project_meeting_meeting_participant_path project, meeting

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
  end
end
