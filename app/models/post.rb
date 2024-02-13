class Post < ApplicationRecord
  belongs_to :user_role
  belongs_to :project
  delegate :user, to: :user_role
end
