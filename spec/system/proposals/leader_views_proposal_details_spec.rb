require 'rails_helper'

describe 'Líder visualiza solicitação' do
  it 'com sucesso' do
    leader = create :user
    project = create :project, user: leader
    id = 38
    proposal_profile = PortfoliorrrProfile.new(id:, name: 'Rodolfo', job_categories: [])
    create :proposal, project:, status: :pending,
                      message: 'Quero participar do projeto!',
                      profile_id: id, email: 'rodolfo@email.com'
    allow(PortfoliorrrProfile).to receive(:find).with(id).and_return(proposal_profile)

    login_as leader, scope: :user
    visit project_proposals_path project
    click_on 'Visualizar'

    expect(page).to have_current_path project_portfoliorrr_profile_path(project, id)
    expect(page).to have_content 'Nova Solicitação!'
    expect(page).to have_content 'Quero participar do projeto!'
    expect(page).to have_field 'Mensagem'
    expect(page).to have_field 'Prazo de validade (em dias)'
    expect(page).to have_button 'Aceitar'
    expect(page).to have_button 'Recusar'
    expect(page).not_to have_button 'Enviar convite'
  end

  it 'e aceita' do
    leader = create :user
    project = create :project, user: leader
    id = 38
    proposal_profile = PortfoliorrrProfile.new(id:, name: 'Rodolfo', job_categories: [])
    proposal_profile.email = 'rodolfo@email.com'
    proposal = create :proposal, project:, status: :pending,
                                 profile_id: id, email: proposal_profile.email
    allow(PortfoliorrrProfile).to receive(:find).with(id).and_return(proposal_profile)
    json = { data: { invitation_id: 3 } }
    fake_response = double('faraday_response', body: json.to_json, success?: true)
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as leader, scope: :user
    visit project_portfoliorrr_profile_path project, id
    click_on 'Aceitar'

    expect(page).to have_current_path project_portfoliorrr_profile_path project, id
    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(proposal.reload.status).to eq 'accepted'
    expect(Invitation.last.project).to eq project
    expect(Invitation.last.profile_id).to eq proposal_profile.id
    expect(Invitation.last.status).to eq 'pending'
  end

  it 'e recusa' do
    leader = create :user
    project = create :project, user: leader
    id = 38
    proposal_profile = PortfoliorrrProfile.new(id:, name: 'Rodolfo', job_categories: [])
    proposal_profile.email = 'rodolfo@email.com'
    proposal = create :proposal, project:, status: :pending,
                                 profile_id: id, email: proposal_profile.email
    allow(PortfoliorrrProfile).to receive(:find).with(id).and_return(proposal_profile)
    proposal_service_spy = spy(ProposalService::Decline)
    stub_const('ProposalService::Decline', proposal_service_spy)
    allow(proposal_service_spy).to receive(:send)

    login_as leader, scope: :user
    visit project_portfoliorrr_profile_path project, id
    click_on 'Recusar'

    expect(page).to have_current_path project_portfoliorrr_profile_path project, id
    expect(page).to have_content 'Solicitação em processamento'
    expect(proposal.reload.status).to eq 'processing'
    expect(page).to have_content 'Em processamento'
    expect(page).to have_field 'Prazo de validade (em dias)', disabled: true
    expect(page).to have_field 'Mensagem', disabled: true
    expect(page).not_to have_button 'Enviar convite'
    expect(page).to have_button 'Aceitar', disabled: true
    expect(page).to have_button 'Recusar', disabled: true
    expect(proposal_service_spy).to have_received(:send)
  end
end
