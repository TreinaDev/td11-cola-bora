require 'action_view'

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user_role

  validates :content, presence: true
end
