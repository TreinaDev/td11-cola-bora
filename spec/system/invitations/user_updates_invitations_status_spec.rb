require 'rails_helper'

describe 'Lider revoga convite' do
  it 'e status muda de pendente para cancelado' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    create(:invitation, project:, profile_id: joao.id, status: :pending)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)
    click_on 'Cancelar convite'

    expect(page).to have_content 'Convite cancelado!'
    expect(current_path).to eq project_portfoliorrr_profile_path(project, joao.id)
    expect(Invitation.last.cancelled?).to eq true
  end

  it 'e vê página com o convite cancelado' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    create(:invitation, project:, profile_id: joao.id, status: :cancelled)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_button 'Enviar convite'
    expect(page).not_to have_button 'Cancelar convite'
    expect(current_path).to eq project_portfoliorrr_profile_path(project, joao.id)
    expect(Invitation.last.cancelled?).to eq true
  end

  it 'e envia novo convite' do
    json = { data: { id: 3 } }
    fake_response = double('faraday_response', status: 200, body: json, success?: true)
    allow(Faraday).to receive(:post).and_return(fake_response)

    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    joao.email = 'joao@email.com'

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    create(:invitation, project:, profile_id: joao.id, status: :cancelled)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)
    fill_in 'Prazo de validade (em dias)', with: 10
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(current_path).to eq project_portfoliorrr_profile_path(project, joao.id)
    expect(Invitation.last.pending?).to eq true
  end
end

describe 'Atualiza status para expirado' do
  it 'quando convite estiver vencido' do
    user = create(:user)
    project = create(:project, user:)
    invitation = create(:invitation, project:, expiration_days: 3, status: :pending)

    travel_to 4.days.from_now do
      login_as(user)
      visit project_portfoliorrr_profile_path(project, invitation.profile_id)

      expect(invitation.reload.expired?).to eq true
    end
  end
end
