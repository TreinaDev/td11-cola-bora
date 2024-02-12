FactoryBot.define do
  factory :proposal do
    project
    sequence(:portfoliorrr_proposal_id) { |n| n }
    status { :pending }
    message { 'Mensagem padrão' }
    sequence(:profile_id) { |n| n }
    sequence(:email) { |n| "proposer#{n}@email.com" }
  end
end
