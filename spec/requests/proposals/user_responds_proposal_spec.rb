require 'rails_helper'

describe 'Usuário responde uma solicitação' do
  context 'para um projeto do qual é lider' do
    it 'como aceita com sucesso' do
      leader = create :user
      project = create :project, user: leader
      profile_id = 38
      profile_email = 'proposal@email.com'
      proposal = create :proposal, project:, profile_id:,
                                   email: profile_email, status: :pending
      params = { invitation: { profile_id:, profile_email: } }
      json = { data: { invitation_id: 1 } }
      fake_response = double 'faraday_response', status: 200, body: json.to_json, success?: true
      allow(Faraday).to receive(:post).and_return fake_response

      login_as leader, scope: :user
      post(project_portfoliorrr_profile_invitations_path(project, profile_id), params:)

      expect(proposal.reload.status).to eq 'accepted'
    end

    it 'como recusada com sucesso' do
      leader = create :user
      project = create :project, user: leader
      proposal = create :proposal, project:, status: :pending
      fake_response = double 'faraday_response', status: 204, success?: true
      allow(Faraday).to receive(:patch).and_return fake_response

      login_as leader, scope: :user
      patch decline_proposal_path(proposal)

      expect(proposal.reload.status).to eq 'declined'
    end
  end

  context 'para um projeto do qual é administrador' do
    it 'como aceita sem sucesso' do
      admin = create :user, cpf: '068.433.960-97'
      project = create :project
      project.user_roles.create({ user: admin, role: :admin })
      profile_id = 39
      profile_email = 'proposal@email.com'
      proposal = create :proposal, project:, profile_id:,
                                   email: profile_email, status: :pending

      login_as admin, scope: :user
      post project_portfoliorrr_profile_invitations_path project, profile_id

      expect(response).to redirect_to root_path
      expect(proposal.reload.status).not_to eq 'accepted'
      expect(proposal.reload.status).to eq 'pending'
    end

    it 'como recusada sem sucesso' do
      admin = create :user, cpf: '068.433.960-97'
      project = create :project
      project.user_roles.create({ user: admin, role: :admin })
      proposal = create :proposal, project:, status: :pending

      login_as admin, scope: :user
      patch decline_proposal_path proposal

      expect(response).to redirect_to root_path
      expect(proposal.reload.status).not_to eq 'declined'
      expect(proposal.reload.status).to eq 'pending'
    end
  end

  context 'para um projeto do qual é contribuidor' do
    it 'como aceita sem sucesso' do
      contributor = create :user, cpf: '068.433.960-97'
      project = create :project
      project.user_roles.create!({ user: contributor, role: :contributor })
      profile_id = 39
      profile_email = 'proposal@email.com'
      proposal = create :proposal, project:, profile_id:,
                                   email: profile_email, status: :pending

      login_as contributor, scope: :user
      post project_portfoliorrr_profile_invitations_path project, profile_id

      expect(response).to redirect_to root_path
      expect(proposal.reload.status).not_to eq 'accepted'
      expect(proposal.reload.status).to eq 'pending'
    end

    it 'como recusada sem sucesso' do
      contributor = create :user, cpf: '068.433.960-97'
      project = create :project
      project.user_roles.create({ user: contributor, role: :contributor })
      proposal = create :proposal, project:, status: :pending

      login_as contributor, scope: :user
      patch decline_proposal_path proposal

      expect(response).to redirect_to root_path
      expect(proposal.reload.status).not_to eq 'declined'
      expect(proposal.reload.status).to eq 'pending'
    end
  end

  context 'para um projeto do qual não é colaborador' do
    it 'como aceita sem sucesso' do
      user = create :user, cpf: '068.433.960-97'
      project = create :project
      profile_id = 39
      proposal = create :proposal, project:, profile_id:, status: :pending

      login_as user, scope: :user
      post project_portfoliorrr_profile_invitations_path project, profile_id

      expect(response).to redirect_to root_path
      expect(proposal.reload.status).not_to eq 'accepted'
      expect(proposal.reload.status).to eq 'pending'
    end

    it 'como recusada sem sucesso' do
      contributor = create :user, cpf: '068.433.960-97'
      project = create :project
      proposal = create :proposal, project:, status: :pending

      login_as contributor, scope: :user
      patch decline_proposal_path proposal

      expect(response).to redirect_to root_path
      expect(proposal.reload.status).not_to eq 'declined'
      expect(proposal.reload.status).to eq 'pending'
    end
  end

  context 'não autenticado' do
    it 'sem sucesso' do
      project = create(:project)
      profile_id = 39
      proposal = create :proposal, project:, profile_id:, status: :pending

      post project_portfoliorrr_profile_invitations_path project, profile_id

      expect(response).to redirect_to new_user_session_path
      expect(proposal.reload.status).not_to eq 'accepted'
      expect(proposal.reload.status).to eq 'pending'
    end

    it 'como recusada sem sucesso' do
      project = create(:project)
      profile_id = 39
      proposal = create :proposal, project:, profile_id:, status: :pending

      patch decline_proposal_path proposal

      expect(response).to redirect_to new_user_session_path
      expect(proposal.reload.status).not_to eq 'declined'
      expect(proposal.reload.status).to eq 'pending'
    end
  end
end
