require 'action_view'

class Comment < ApplicationRecord
  validates :content, presence: true
  include ActionView::Helpers::DateHelper

  belongs_to :post
  belongs_to :user_role

  def formatted_date
    "Postado há #{time_ago_in_words(created_at)}"
  end
end
