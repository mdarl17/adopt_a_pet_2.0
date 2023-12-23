class PetApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum status: { "Pending": 0, "Approved": 1, "Rejected": 2 }

  def self.pending_pet_applications(p_id) 
    joins(:application).where("pet_applications.pet_id = ?", p_id).where("applications.status = 1").count > 1
  end

end