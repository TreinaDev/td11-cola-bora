module InvitationHelper
  include ActionView::Helpers::DateHelper

  def expiration_date_helper(invitation)
    return t('invitations.no_expiration_date') if invitation.expiration_date.nil?

    "Expira em #{distance_of_time_in_words Time.zone.now, invitation.expiration_date}"
  end
end
