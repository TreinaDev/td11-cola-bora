require 'rails_helper'

describe 'Usuário quer enviar convite' do
  it 'a partir do perfil do usuário da Portfoliorrr' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')
    create(:project, user:, title: 'Segundo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos', job_category: 'Desenvolvimento')

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)
    fill_in 'Prazo de validade (em dias)', with: 10
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(project.invitations.last.pending?).to eq true
  end

  it 'mas o usuário da Portfoliorrr já foi convidado para o projeto' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos', job_category: 'Desenvolvimento')

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    create(:invitation, project:, profile_id: 1)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_button 'Cancelar convite'
    expect(page).not_to have_button 'Enviar convite'
  end
end
