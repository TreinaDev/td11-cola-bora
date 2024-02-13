require 'rails_helper'

RSpec.describe InvitationHelper, type: :helper do
  describe 'invitation_expiration_date' do
    it 'retorna "Sem prazo de validade" se convite não tem data de validade' do
      invitation = create :invitation, expiration_days: nil

      expect(invitation_expiration_date(invitation)).to eq 'Sem prazo de validade'
    end

    it 'retorna tempo em dias para expiração do convite' do
      invitation = create :invitation, expiration_days: 5

      expect(invitation_expiration_date(invitation)).to eq 'Expira em 4 dias'
    end

    it 'retorna tempo em horas para expiração do convite' do
      travel_to Time.zone.today.noon do
        invitation = create :invitation, expiration_days: 1

        expect(invitation_expiration_date(invitation)).to eq 'Expira em aproximadamente 12 horas'
      end
    end

    it 'retorna tempo em minutos para expiração do convite' do
      travel_to Time.zone.today.beginning_of_day do
        invitation = create :invitation, expiration_days: 0

        expect(invitation_expiration_date(invitation)).to eq 'Expira em menos de um minuto'
      end
    end
  end
end
