module ProposalHelper
  def proposal_card_color(status)
    case status
    in 'pending' then 'primary'
    in 'accepted' then 'success'
    in 'declined' then 'danger'
    in 'cancelled' then 'secondary'
    else 'light'
    end
  end
end
