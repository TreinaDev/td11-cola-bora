class Post < ApplicationRecord
  belongs_to :user_role
  belongs_to :project
end
