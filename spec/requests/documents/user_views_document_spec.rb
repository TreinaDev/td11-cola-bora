require 'rails_helper'

describe 'Usuário acessa documento' do
  context 'de um projeto que é membro' do
    it 'com sucesso' do
      project = create(:project)
      document_owner = create(:user, cpf: '722.941.100-99')
      document = create(:document, project:, user: document_owner)
      contributor = create(:user, cpf: '848.228.240-98')
      project.user_roles.create!(user: contributor)

      login_as contributor, scope: :user
      get document_path(document)

      expect(response).to have_http_status :ok
    end
  end

  context 'de um projeto que não é membro' do
    it 'sem sucesso' do
      project = create(:project)
      document_owner = create(:user, cpf: '722.941.100-99')
      document = create(:document, project:, user: document_owner)
      non_contributor = create(:user, cpf: '848.228.240-98')

      login_as non_contributor, scope: :user
      get document_path(document)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não é membro deste projeto'
    end
  end
end
