class Proposal < ApplicationRecord
  belongs_to :project

  enum status: {
    pending: 1,
    accepted: 5,
    declined: 10,
    cancelled: 15
  }
end
