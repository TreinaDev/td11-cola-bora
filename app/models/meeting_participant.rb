class MeetingParticipant < ApplicationRecord
  belongs_to :meeting
  belongs_to :user_role
  delegate :user, to: :user_role
end
