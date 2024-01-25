require 'rails_helper'

RSpec.describe Document, type: :model do
  describe '#valid?' do
    context 'false' do
      it 'sem título' do
        document = build(:project).documents.new(title: '')

        expect(document.valid?).to be false
        expect(document.errors).to include :title
      end

      it 'sem arquivo anexado' do
        document = build(:project).documents.new(file: nil)

        expect(document.valid?).to be false
        expect(document.errors).to include :file
      end

      it 'com arquivo não suportado' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/invalid_upload_file.txt')
        )

        expect(document.valid?).to be false
        expect(document.errors).to include :file
        expect(document.errors.full_messages).to include 'Arquivo não suportado.'
      end
    end

    context 'true' do
      it 'com arquivo JPG' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_jpg.jpg')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo PNG' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_png.png')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo MP4' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_video.mp4')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo MP3' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_audio.mp3')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo PDF' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_pdf.pdf')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo Word' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_word_file.docx')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo Excel' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_excel.xlsx')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo PowerPoint' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_ppt.ppt')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo CSV' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_csv.csv')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end

      it 'com arquivo ZIP' do
        document = build(:project).documents.new(
          file: fixture_file_upload('spec/support/files/sample_zip.zip')
        )

        document.valid?

        expect(document.errors).not_to include :file
      end
    end
  end
end
