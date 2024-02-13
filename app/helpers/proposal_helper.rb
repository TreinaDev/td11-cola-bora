module ProposalHelper
  def proposal_card_color(status)
    case status
    in 'pending' then 'primary'
    in 'accepted' then 'success'
    in 'declined' then 'danger'
    in 'cancelled' | 'expired' then 'tertiary'
    in 'processing' then 'dark'
    else 'light'
    end
  end
end
