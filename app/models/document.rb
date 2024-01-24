class Document < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one_attached :file

  validates :title, :file, presence: true
  validates :file, content_type: {
    in: %w[image/jpg image/png image/jpeg application/pdf application/msword application/vnd.ms-excel
           application/vnd.ms-powerpoint audio/mpeg video/mp4 application/zip],
    message: I18n.t('not_supported')
  }
end
