require 'rails_helper'

describe 'Líder aceita solicitação' do
  it 'com sucesso' do
    leader = create :user
    project = create :project, user: leader
    id = 38
    proposal_profile = PortfoliorrrProfile.new(id:, name: 'Rodolfo', job_categories: [])
    create :proposal, project:, status: :pending,
                      message: 'Quero participar do projeto!',
                      profile_id: id, email: 'rodolfo@email.com'
    allow(PortfoliorrrProfile).to receive(:find).with(id).and_return(proposal_profile)
    json = { data: { invitation_id: 3 } }
    fake_response = double('faraday_response', status: 200, body: json.to_json, success?: true)
    allow(Faraday).to receive(:post).and_return(fake_response)

    login_as leader, scope: :user
    visit project_proposals_path project
    click_on 'Visualizar'

    expect(page).to have_current_path project_portfoliorrr_profile_path(project, id)
    expect(page).to have_content 'Solicitação pendente'
    expect(page).to have_content 'Quero participar do projeto!'
    expect(page).to have_field 'Mensagem'
    expect(page).to have_field 'Prazo de validade (em dias)'
    expect(page).to have_button 'Aceitar'
    expect(page).not_to have_button 'Enviar convite'
  end
end
