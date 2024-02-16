FactoryBot.define do
  factory :comment do
    content { 'Gostei muito desse post!' }
    post
    user_role
  end
end
