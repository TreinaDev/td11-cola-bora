require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'card_color' do
    it 'Retorna primary se status é pending' do
      status = 'pending'

      expect(card_color(status)).to eq 'primary'
    end

    it 'Retorna success se status é accepted' do
      status = 'accepted'

      expect(card_color(status)).to eq 'success'
    end

    it 'Retorna danger se status é declined' do
      status = 'declined'

      expect(card_color(status)).to eq 'danger'
    end

    it 'Retorna tertiary se status é cancelled' do
      status = 'cancelled'

      expect(card_color(status)).to eq 'tertiary'
    end

    it 'Retorna tertiary se status é expired' do
      status = 'expired'

      expect(card_color(status)).to eq 'tertiary'
    end

    it 'Retorna dark se status é processing' do
      status = 'processing'

      expect(card_color(status)).to eq 'dark'
    end

    it 'Retorna secondary se status não existe' do
      status = 'foo'

      expect(card_color(status)).to eq 'light'
    end
  end
end
