require 'rails_helper'

describe 'Usuário vê a lista de documentos' do
  context 'de um projeto que é membro' do
    it 'com sucesso' do
      project = create(:project)
      document_owner = create(:user, cpf: '744.240.030-27')
      create(:document, project:, user: document_owner)
      member = create(:user, cpf: '997.971.230-90')
      project.user_roles.create(user: member)

      login_as member, scope: :user
      get project_documents_path(project)

      expect(response).to have_http_status :ok
    end
  end

  context 'de um projeto que não é membro' do
    it 'sem sucesso' do
      project = create(:project)
      document_owner = create(:user, cpf: '471.606.780-79')
      create(:document, project:, user: document_owner)
      non_member = create(:user, cpf: '680.180.260-76')

      login_as non_member, scope: :user
      get project_documents_path(project)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não é membro deste projeto'
    end
  end
end
