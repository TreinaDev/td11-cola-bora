require 'rails_helper'

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

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(project.documents.count).to eq 1
      expect(document.title).to eq 'Teste de request'
      expect(document.description).to eq 'Descrição'
      expect(document.user).to eq leader
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_jpg.jpg')
    end

    it 'por um colaborador' do
      project = create(:project)
      contributor = create(:user, cpf: '747.860.990-23')
      project.user_roles.create(user: contributor)
      params = { document: {
        title: 'Documento de contribuidor',
        description: 'Descrição',
        file: fixture_file_upload('spec/support/files/sample_png.png')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_png.png')
    end

    it 'com extensão mp4' do
      project = create(:project)
      contributor = create(:user, cpf: '616.782.230-18')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo mp4',
        file: fixture_file_upload('spec/support/files/sample_video.mp4')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_video.mp4')
    end

    it 'com extensão mp3' do
      project = create(:project)
      contributor = create(:user, cpf: '038.580.790-22')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo mp3',
        file: fixture_file_upload('spec/support/files/sample_audio.mp3')
      } }

      login_as contributor, sope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_audio.mp3')
    end

    it 'com extensão docx' do
      project = create(:project)
      contributor = create(:user, cpf: '706.259.640-04')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo Word',
        file: fixture_file_upload('spec/support/files/sample_word_file.docx')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_word_file.docx')
    end

    it 'com extensão pdf' do
      project = create(:project)
      contributor = create(:user, cpf: '279.907.860-52')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo pdf',
        file: fixture_file_upload('spec/support/files/sample_pdf.pdf')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_pdf.pdf')
    end

    it 'com extensão xlsx' do
      project = create(:project)
      contributor = create(:user, cpf: '471.301.980-10')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo Excel',
        file: fixture_file_upload('spec/support/files/sample_excel.xlsx')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_excel.xlsx')
    end

    it 'com extensão ppt' do
      project = create(:project)
      contributor = create(:user, cpf: '939.351.790-81')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo Power Point',
        file: fixture_file_upload('spec/support/files/sample_ppt.ppt')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_ppt.ppt')
    end

    it 'com extensão csv' do
      project = create(:project)
      contributor = create(:user, cpf: '939.351.790-81')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo CSV',
        file: fixture_file_upload('spec/support/files/sample_csv.csv')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_csv.csv')
    end

    it 'com extensão zip' do
      project = create(:project)
      contributor = create(:user, cpf: '939.351.790-81')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Arquivo ZIP',
        file: fixture_file_upload('spec/support/files/sample_zip.zip')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      document = project.reload.documents.last
      expect(response).to redirect_to document_path(document)
      expect(document.user).to eq contributor
      expect(document.file.attached?).to be true
      expect(document.file.byte_size).to eq File.size('spec/support/files/sample_zip.zip')
    end
  end

  context 'sem sucesso' do
    it 'por um usuário deslogado' do
      project = create(:project)
      params = { document: {
        title: 'Upload sem sucesso',
        file: fixture_file_upload('spec/support/files/sample_csv.csv')
      } }

      post(project_documents_path(project), params:)

      expect(response).to redirect_to new_user_session_path
      expect(project.documents).to be_empty
    end

    it 'por um usuário não pertencente ao projeto' do
      project = create(:project)
      non_member = create(:user, cpf: '161.176.400-99')
      params = { document: {
        title: 'Documento de um membro não pertencente ao projeto',
        file: fixture_file_upload('spec/support/files/sample_audio.mp3')
      } }

      login_as non_member, scope: :user
      post(project_documents_path(project), params:)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Não foi possível completar sua requisição.'
      expect(project.documents).to be_empty
    end

    it 'com extensão não permitida' do
      project = create(:project)
      contributor = create(:user, cpf: '866.726.620-57')
      project.user_roles.create!(user: contributor)
      params = { document: {
        title: 'Documento com arquivo não suportado',
        file: fixture_file_upload('spec/support/files/invalid_upload_file.txt')
      } }

      login_as contributor, scope: :user
      post(project_documents_path(project), params:)

      expect(response).to have_http_status :unprocessable_entity
      expect(flash[:alert]).to eq 'Não foi possível adicionar o documento.'
      expect(project.documents).to be_empty
    end
  end
end
