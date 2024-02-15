require 'rails_helper'

RSpec.describe InvitationHelper, type: :helper do
  describe 'invitation_expiration_date' do
    it 'retorna "Sem prazo de validade" se convite não tem data de validade' do
      invitation = create :invitation, expiration_days: nil

      expect(invitation_expiration_date(invitation)).to eq 'Sem prazo de validade'
    end

    it 'retorna tempo em dias para expiração do convite' do
      travel_to Time.zone.now.beginning_of_day do
        invitation = create :invitation, expiration_days: 5

        expect(invitation_expiration_date(invitation)).to eq 'Expira em 5 dias'
      end
    end
  end
end
