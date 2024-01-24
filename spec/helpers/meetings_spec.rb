require 'rails_helper'

RSpec.describe MeetingsHelper, type: :helper do
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
  end
end
