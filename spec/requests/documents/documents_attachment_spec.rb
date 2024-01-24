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
          file: fixture_file_upload('spec/support/files/sample_jpg.jpg')
        } }

        login_as leader, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.count).to eq 1
        expect(project.documents.last.title).to eq 'Teste de request'
        expect(project.documents.last.description).to eq 'Descrição'
        expect(project.documents.last.user).to eq leader
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_jpg.jpg')
      end

      it 'por um colaborador' do
        project = create(:project)
        contributor = create(:user, cpf: '747.860.990-23', email: 'colaborador@email.com')
        project.user_roles.create(user: contributor)
        params = { document: {
          title: 'Documento de contribuidor',
          description: 'Descrição',
          file: fixture_file_upload('spec/support/files/sample_png.png')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)
        project.reload

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_png.png')
      end

      it 'com extensão mp4' do
        project = create(:project)
        contributor = create(:user, cpf: '616.782.230-18', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
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
          title: 'Arquivo Word',
          file: fixture_file_upload('spec/support/files/sample_word_file.docx')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_word_file.docx')
      end

      it 'com extensão pdf' do
        project = create(:project)
        contributor = create(:user, cpf: '279.907.860-52', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          title: 'Arquivo pdf',
          file: fixture_file_upload('spec/support/files/sample_pdf.pdf')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_pdf.pdf')
      end

      it 'com extensão xlsx' do
        project = create(:project)
        contributor = create(:user, cpf: '471.301.980-10', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          title: 'Arquivo Excel',
          file: fixture_file_upload('spec/support/files/sample_excel.xlsx')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_excel.xlsx')
      end

      it 'com extensão ppt' do
        project = create(:project)
        contributor = create(:user, cpf: '939.351.790-81', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          title: 'Arquivo Power Point',
          file: fixture_file_upload('spec/support/files/sample_ppt.ppt')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_ppt.ppt')
      end

      it 'com extensão csv' do
        project = create(:project)
        contributor = create(:user, cpf: '939.351.790-81', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          title: 'Arquivo CSV',
          file: fixture_file_upload('spec/support/files/sample_csv.csv')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_csv.csv')
      end

      it 'com extensão zip' do
        project = create(:project)
        contributor = create(:user, cpf: '939.351.790-81', email: 'contributor@email.com')
        project.user_roles.create!(user: contributor)
        params = { document: {
          title: 'Arquivo ZIP',
          file: fixture_file_upload('spec/support/files/sample_zip.zip')
        } }

        login_as contributor, scope: :user
        post(project_documents_path(project), params:)

        expect(response).to redirect_to project_documents_path(project)
        expect(project.documents.last.user).to eq contributor
        expect(project.documents.last.file.attached?).to be true
        expect(project.documents.last.file.byte_size).to eq File.size('spec/support/files/sample_zip.zip')
      end
    end

    context 'sem sucesso' do
      it 'por um usuário deslogado'
      it 'por um usuário não pertencente ao projeto'
      it 'com extensão não permitida'
    end
  end
end
