require 'rails_helper'

describe 'Usuário quer enviar convite' do
  it 'a partir do perfil do usuário da Portfoliorrr' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')
    create(:project, user:, title: 'Segundo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(name: 'Desenvolvimento')])

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

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(name: 'Desenvolvimento')])

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    create(:invitation, project:, profile_id: 1)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_button 'Cancelar convite'
    expect(page).not_to have_button 'Enviar convite'
  end

  it 'mas não é o líder do projeto' do
    user_one = create(:user)
    user_two = create(:user, cpf: '69734049011')

    project = create(:project, user: user_one)
    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(name: 'Desenvolvimento')])
    create(:invitation, project:, profile_id: joao.id)

    login_as user_two
    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_current_path root_path
  end

  it 'não está autenticado' do
    project = create(:project)
    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(name: 'Desenvolvimento')])
    create(:invitation, project:, profile_id: joao.id)

    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_current_path new_user_session_path
  end
end
