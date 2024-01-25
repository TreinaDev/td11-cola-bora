require 'rails_helper'

describe 'Lider revoga convite' do
  it 'e status muda de pendente para cancelado' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos', job_category: 'Desenvolvimento')

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    create(:invitation, project:, profile_id: joao.id)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)
    click_on 'Cancelar convite'

    expect(page).to have_content 'Convite cancelado!'
    expect(current_path).to eq project_portfoliorrr_profile_path(project, joao.id)
    expect(Invitation.last.cancelled?).to eq true
  end

  it 'e envia novo convite' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos', job_category: 'Desenvolvimento')

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

  xit 'apenas se status for igual a pendente' do
  end
end
