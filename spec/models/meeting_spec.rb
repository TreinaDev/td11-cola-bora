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

    context 'prazo deve ser futuro' do
      it 'falso se data é no passado' do
        meeting = FactoryBot.build(:meeting, datetime: 1.day.ago.to_date)

        meeting.valid?

        expect(meeting.errors.full_messages).to include 'Data e horário deve ser futuro.'
      end

      it 'verdadeiro se data é hoje, mas horário é futuro' do
        meeting = FactoryBot.build(:meeting, datetime: 1.hour.from_now)

        meeting.valid?

        expect(meeting.errors.full_messages).not_to include 'Data e horário deve ser futuro.'
      end

      it 'falso se data é hoje, mas horário é passado' do
        meeting = FactoryBot.build(:meeting, datetime: 1.hour.ago)

        meeting.valid?

        expect(meeting.errors.full_messages).to include 'Data e horário deve ser futuro.'
      end

      it 'verdadeiro se data é no futuro' do
        meeting = FactoryBot.build(:meeting, datetime: 1.day.from_now.to_date)

        meeting.valid?

        expect(meeting.errors.full_messages).not_to include 'Data e horário deve ser futuro.'
      end
    end
  end
end
