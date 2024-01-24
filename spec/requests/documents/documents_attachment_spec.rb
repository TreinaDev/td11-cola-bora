require 'rails_helper'

RSpec.describe 'Documento', type: :request do
  describe 'Documento é anexado ao projeto' do
    context 'com sucesso' do
      it 'pelo líder de projeto' do
        leader = create(:user)
        project = create(:project, user: leader)
        params = { document: {
          title: 'Teste de request',
          description: 'Descrição',
          file: fixture_file_upload('spec/support/files/imagem1.jpg')
        } }

        login_as leader, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.count).to eq 1
        expect(project.documents.last.title).to eq 'Teste de request'
        expect(project.documents.last.description).to eq 'Descrição'
        expect(project.documents.last.user).to eq leader
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/imagem1.jpg')
      end

      it 'por um colaborador' do
        project = create(:project)
        contributor = create(:user, cpf: '747.860.990-23', email: 'colaborador@email.com')
        project.user_roles.create(user: contributor)
        params = { document: {
          user: contributor,
          title: 'Documento de contribuidor',
          description: 'Descrição',
          file: fixture_file_upload('spec/support/files/imagem1.jpg')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)
        project.reload

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/imagem1.jpg')
      end

      it 'com extensão png' do
        project = create(:project)
        contributor = create(:user, cpf: '054.101.990-22', email: 'colaborador@email.com')
        project.user_roles.create(user: contributor)
        params = { document: {
          user: contributor,
          title: 'Arquivo png',
          file: fixture_file_upload('spec/support/files/imagem1.png')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/imagem1.png')
      end

      it 'com extensão mp4' do
        project = create(:project)
        contributor = create(:user, cpf: '616.782.230-18', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          user: contributor,
          title: 'Arquivo mp4',
          file: fixture_file_upload('spec/support/files/sample_video.mp4')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_video.mp4')
      end

      it 'com extensão mp3' do
        project = create(:project)
        contributor = create(:user, cpf: '038.580.790-22', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          user: contributor,
          title: 'Arquivo mp3',
          file: fixture_file_upload('spec/support/files/sample_audio.mp3')
        } }

        login_as contributor, sope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_audio.mp3')
      end

      it 'com extensão docx' do
        project = create(:project)
        contributor = create(:user, cpf: '706.259.640-04', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          user: contributor,
          title: 'Arquivo docx',
          file: fixture_file_upload('spec/support/files/sample_word_file.docx')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_word_file.docx')
      end

      it 'com extensão pdf'
      it 'com extensão xls'
      it 'com extensão ppt'
    end

    context 'sem sucesso' do
      it 'por um usuário deslogado'
      it 'por um usuário não pertencente ao projeto'
      it 'com extensão não permitida'
    end
  end
end
