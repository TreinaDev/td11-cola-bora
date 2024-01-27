require 'rails_helper'

RSpec.describe MeetingHelper, type: :helper do
  describe 'Meeting Helper' do
    context 'formatação da duração' do
      it '45 minutos' do
        expect(format_duration(45)).to eq '45m'
      end

      it '120 minutos' do
        expect(format_duration(120)).to eq '2h'
      end

      it '75 minutos' do
        expect(format_duration(75)).to eq '1h15'
      end
    end
    context 'link para o endereço' do
      it 'se o endereço for um link' do
        expect(link_to_address('https://meet.google.com')).to have_selector('a')
      end
      it 'se o endereço for uma localização' do
        expect(link_to_address('Av. Paulista, 9585')).not_to have_selector('a')
        expect(link_to_address('Av. Paulista, 9585')).to eq 'Av. Paulista, 9585'
      end
    end
  end
end
