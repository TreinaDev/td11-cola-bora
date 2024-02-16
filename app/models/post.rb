class Post < ApplicationRecord
  belongs_to :user_role
  belongs_to :project
  has_many :comments, dependent: :destroy
  delegate :user, to: :user_role

  validates :title, :body, presence: true
end
