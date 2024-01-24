require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe '#Valid?' do
    context 'presence' do
      it 'Título não pode ficar em branco' do
        meeting = FactoryBot.build(:meeting, title: '')

        meeting.valid?

        expect(meeting.errors[:title]).to include 'não pode ficar em branco'
      end
      it 'Data e horário não pode ficar em branco' do
        meeting = FactoryBot.build(:meeting, datetime: '')

        meeting.valid?

        expect(meeting.errors[:datetime]).to include 'não pode ficar em branco'
      end
      it 'Duração não pode ficar em branco' do
        meeting = FactoryBot.build(:meeting, duration: '')

        meeting.valid?

        expect(meeting.errors[:duration]).to include 'não pode ficar em branco'
      end
      it 'Endereço não pode ficar em branco' do
        meeting = FactoryBot.build(:meeting, address: '')

        meeting.valid?

        expect(meeting.errors[:address]).to include 'não pode ficar em branco'
      end
    end
  end
end
