class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
 
  validates_presence_of :name, :street, :city, :state, :zip, :descr, :status

  enum status: {"In progress": 0, "Pending": 1, "Approved": 2, "Rejected": 3}

  def get_pet_app(pet_id) 
    PetApplication.where(pet_id: pet_id, application_id: self.id).first
  end

  def approved? 
    num_pets_on_app = pet_applications.select("COUNT(*) AS pet_count")[0].pet_count
    num_pets_approved = pet_applications.select("COUNT(pet_applications.status) AS pet_app_status").where("pet_applications.status = 1")[0].pet_app_status
    
    num_pets_approved == num_pets_on_app
  end

  def rejected? 
    pet_applications.select("COUNT(pet_applications.status) AS pet_app_status").where("pet_applications.status = 2")[0].pet_app_status > 0
  end

end