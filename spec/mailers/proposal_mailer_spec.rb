require 'rails_helper'

RSpec.describe ProposalMailer, type: :mailer do
  describe '#notify_leader' do
    it 'envia email para o líder do projeto com sucesso' do
      leader = create :user, email: 'leader@email.com'
      project = create :project, user: leader,
                                 title: 'Canal de Youtube'
      proposal = create :proposal, project:,
                                   message: 'Gostaria de participar',
                                   email: 'proposer_portfoliorrr@email.com'

      mail = ProposalMailer.with(proposal:).notify_leader

      expect(mail.to).to include 'leader@email.com'
      expect(mail.subject).to include 'Nova solicitação para seu projeto!'
      expect(mail.body.encoded).to include 'Seu projeto Canal de Youtube recebeu uma nova solicitação!'
      expect(mail.body.encoded).to include 'Solicitante: proposer_portfoliorrr@email.com'
      expect(mail.body.encoded).to include 'Mensagem: Gostaria de participar'
      link = project_portfoliorrr_profile_url project, proposal.profile_id
      button = "<a href=\"#{link}\">Visualizar solicitação</a>"
      expect(mail.body.encoded).to include button
    end
  end
end
