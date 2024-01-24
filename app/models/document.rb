class Document < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one_attached :file

  validates :title, :file, presence: true
  validates :file, content_type: {
    in: %w[image/jpg
           image/png
           image/jpeg
           application/pdf
           application/vnd.openxmlformats-officedocument.wordprocessingml.document
           application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
           application/vnd.ms-powerpoint
           audio/mpeg
           video/mp4],
    message: I18n.t('not_supported')
  }
end
