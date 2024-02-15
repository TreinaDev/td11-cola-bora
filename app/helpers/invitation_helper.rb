module InvitationHelper
  include ActionView::Helpers::DateHelper

  def invitation_expiration_date(invitation)
    return I18n.t('invitations.no_expiration_date') if invitation.expiration_date.nil?

    "Expira em #{distance_of_time_in_words Time.zone.now, invitation.expiration_date}"
  end
end
