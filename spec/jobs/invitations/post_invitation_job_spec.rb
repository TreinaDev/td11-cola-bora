require 'rails_helper'

RSpec.describe PostInvitationJob, type: :job do
  describe '#perform' do
    context 'chama InvitationService::PortfoliorrrPost' do
      it 'com sucesso' do
        invitation = create :invitation
        service_spy = spy(InvitationService::PortfoliorrrPost)
        stub_const('InvitationService::PortfoliorrrPost', service_spy)
        allow(service_spy).to receive(:send)

        PostInvitationJob.perform_now invitation

        expect(service_spy).to have_received(:send).with invitation
      end

      it 'não enfileira em caso de sucesso' do
        json = { data: { invitation_id: 33 } }
        fake_response = double('faraday_response', body: json.to_json, success?: true)
        allow(Faraday).to receive(:post).and_return fake_response
        invitation = create :invitation

        expect do
          PostInvitationJob.perform_now invitation
        end.not_to have_enqueued_job
      end

      it 'enfileira nova tentativa em caso de falha' do
        fake_response = double('faraday_response', success?: false)
        allow(Faraday).to receive(:post).and_return fake_response
        invitation = create :invitation

        expect do
          PostInvitationJob.perform_now invitation
        end.to have_enqueued_job
      end
    end

    it 'deleta convite depois de 5 tentativas sem sucesso'
  end
end
