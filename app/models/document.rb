class Document < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one_attached :file

  validates :title, :file, presence: true
end
