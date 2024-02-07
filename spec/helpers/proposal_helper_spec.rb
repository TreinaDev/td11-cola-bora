require 'rails_helper'

RSpec.describe ProposalHelper, type: :helper do
  describe 'proposal_card_color' do
    it 'Retorna primary se status é pending' do
      status = 'pending'

      expect(proposal_card_color(status)).to eq 'primary'
    end

    it 'Retorna success se status é accepted' do
      status = 'accepted'

      expect(proposal_card_color(status)).to eq 'success'
    end

    it 'Retorna danger se status é declined' do
      status = 'declined'

      expect(proposal_card_color(status)).to eq 'danger'
    end

    it 'Retorna secondary se status é cancelled' do
      status = 'cancelled'

      expect(proposal_card_color(status)).to eq 'secondary'
    end

    it 'Retorna secondary se status não existe' do
      status = 'foo'

      expect(proposal_card_color(status)).to eq 'light'
    end
  end
end
