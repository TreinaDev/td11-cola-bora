FactoryBot.define do
  factory :meeting_participant do
    meeting
    user_role
  end
end
