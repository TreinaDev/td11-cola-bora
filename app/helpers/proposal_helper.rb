module ProposalHelper
  def proposal_card_color(status)
    case status
    in 'pending' then 'primary'
    in 'accepted' then 'success'
    in 'declined' then 'danger'
    in 'cancelled' then 'secondary'
    in 'processing' then 'dark'
    else 'light'
    end
  end
end
