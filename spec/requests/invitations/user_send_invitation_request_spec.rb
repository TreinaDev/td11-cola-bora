require 'rails_helper'

describe 'Usuário envia um convite sendo lider' do
  it 'para alguem que ja tem convite pendente' do
    user = create(:user)
    project = create(:project, user:, title: 'Meu novo projeto')
    create(:project, user:, title: 'Segundo projeto')
    joao = PortfoliorrrProfile.new(id: 1, name: 'João Marcos',
                                   job_categories: [JobCategory.new(id: 1, name: 'Desenvolvimento')])
    joao.email = 'joao@email.com'
    create :invitation, project:, profile_id: joao.id, status: :pending, profile_email: joao.email

    login_as user
    params = {
      invitation: {
        profile_email: joao.email,
        profile_id: joao.id
      }
    }
    post(project_portfoliorrr_profile_invitations_path(project, joao.id), params:)

    expect(flash[:alert]).to eq 'Esse usuário possui convite pendente'
    expect(response).to redirect_to project_portfoliorrr_profile_path(project, joao.id)
  end
end
