require 'rails_helper'

RSpec.describe PortfoliorrrInvitation, type: :model do
  context '#post_invitation' do
    xit 'retorna 200 e o id do convite na portfoliorrr' do
      invitation_spy = spy(PortfoliorrrInvitation)
      stub_const('PortfoliorrrInvitation', invitation_spy)    
      expect(invitation_spy).to have_received(:post_invitation)
      #chama o método com o mock
      #espera ele retornar um dado'
    end

    xit 'bad request e convite é cancelado'

    xit 'server error e convite é cancelado'

    xit 'não consegue se conectar com a API'
  end
end