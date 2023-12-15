class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum status: { "Pending": 0, "Approved": 1, "Rejected": 2 }
end