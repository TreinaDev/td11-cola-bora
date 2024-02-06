class Proposal < ApplicationRecord
  belongs_to :project

  validates :profile_id, presence: true
  validates :profile_id, numericality: { greater_than_or_equal_to: 1 }

  enum status: {
    pending: 1,
    accepted: 5,
    declined: 10,
    cancelled: 15
  }
end
