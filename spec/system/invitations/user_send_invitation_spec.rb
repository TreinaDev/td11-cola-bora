require 'rails_helper'

describe 'Usuário quer enviar convite' do
  it 'a partir do perfil do usuário da Portfoliorrr' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')
    create(:project, user:, title: 'Segundo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    joao.email = 'joao@email.com'

    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(joao)

    login_as user
    visit project_portfoliorrr_profile_path(project, joao.id)
    fill_in 'Prazo de validade (em dias)', with: 10
    fill_in 'Mensagem', with: 'Adoraria que fizesse parte do meu projeto'
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(page).to have_content 'Mensagem: Adoraria que fizesse parte do meu projeto'
    expect(page).to have_content "Validade: #{I18n.l(10.days.from_now.to_date)}"
    expect(project.invitations.last.profile_email).to eq 'joao@email.com'
    expect(project.invitations.last.pending?).to eq true
  end

  it 'mas o usuário da Portfoliorrr já foi convidado para o projeto' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')

    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])

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
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    create(:invitation, project:, profile_id: joao.id)

    login_as user_two
    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_current_path root_path
  end

  it 'não está autenticado' do
    project = create(:project)
    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    create(:invitation, project:, profile_id: joao.id)

    visit project_portfoliorrr_profile_path(project, joao.id)

    expect(page).to have_current_path new_user_session_path
  end

  it 'e o usuário ja faz parte do projeto' do
    owner = create(:user)
    project = create(:project, user: owner, title: 'Meu novo projeto')
    random_user_id = 123
    create(:invitation, project:, profile_id: random_user_id, profile_email: 'random@email.com')
    profile = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                      job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    profile.email = 'joao@email.com'
    user = create :user, cpf: '000.000.001-91', email: profile.email
    create :user_role, project:, user:, role: :contributor
    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(profile)

    login_as owner
    visit project_portfoliorrr_profile_path(project, profile.id)
    fill_in 'Prazo de validade (em dias)', with: 3
    fill_in 'Mensagem', with: 'Ola pessoa'
    click_on 'Enviar convite'

    expect(page).to have_content 'Este usuário já faz parte do projeto.'
    expect(page).to have_button 'Enviar convite'
    expect(page).not_to have_button 'Cancelar convite'
    expect(Invitation.last.profile_email).not_to eq 'joao@email.com'
    expect(current_path).to eq project_portfoliorrr_profile_path(project, profile.id)
  end

  it 'e não preenche nada' do
    owner = create(:user)
    project = create(:project, user: owner, title: 'Meu novo projeto')
    random_user_id = 123
    create(:invitation, project:, profile_id: random_user_id, profile_email: 'random@email.com')
    profile = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                      job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    profile.email = 'joao@email.com'
    allow(PortfoliorrrProfile).to receive(:find).with(1).and_return(profile)

    login_as owner
    visit project_portfoliorrr_profile_path(project, profile.id)
    fill_in 'Prazo de validade (em dias)', with: ''
    fill_in 'Mensagem', with: ''
    click_on 'Enviar convite'

    expect(page).to have_content 'Convite enviado com sucesso!'
    expect(page).not_to have_content 'Mensagem:'
    expect(page).to have_content 'Validade: Sem prazo de validade'
    expect(project.invitations.last.profile_email).to eq 'joao@email.com'
    expect(project.invitations.last.pending?).to eq true
  end
end
