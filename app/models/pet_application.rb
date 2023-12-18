class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum status: { "Pending": 0, "Approved": 1, "Rejected": 2 }

  def update_pet_status(button)
    if button == "Approve"

    elsif button == "Reject"
      self.update!(status: 2)
    else
      self
   end
  end

end