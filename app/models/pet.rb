class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  validates :adoptable, inclusion: [true, false]

  belongs_to :shelter

  has_many :pet_applications
  has_many :applications, through: :pet_applications

  def self.pet_search(name) 
    where("name = ?", name)
  end

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end


end
