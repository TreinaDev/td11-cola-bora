require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '#valid?' do
    context 'expiration_days' do
      it 'retorna falso se expiration_days é menor que zero' do
        invitation = build(:invitation, expiration_days: -1)

        expect(invitation).not_to be_valid
        expect(invitation.errors[:expiration_days]).to include 'deve ser maior ou igual a 0'
      end
    end
  end
end
