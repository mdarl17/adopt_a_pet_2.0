class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(*) AS pets_count")
      .joins("INNER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def self.reverse_alpha 
    find_by_sql(
      "SELECT shelters.*
      FROM shelters 
      ORDER BY shelters.name DESC"
    )
  end

  def self.pending_apps 
    select("shelters.*")
      .distinct
      .joins(pets: { pet_applications: :application })
      .where("applications.status = ?", 1)
  end

  def self.asc_alpha 
    self.order(:name)
  end

  def get_name 
    Shelter.find_by_sql("SELECT shelters.name FROM shelters WHERE id = #{self.id}").first.name
  end

  def get_address
    Shelter.find_by_sql("SELECT shelters.city FROM shelters WHERE id = #{self.id}").first.city
  end
  
  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    pets.order(:name)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where("age >= ?", age_filter)
  end

  def average_age 
    pets.select("AVG(pets.age) AS avg_age")
        .joins(:shelter)
        .group("shelters.id")[0]
        .avg_age
        .to_f.round(1)
  end

  def num_pets_adopted 
    pets.where(adoptable: false).count
  end

  def action_required 
    pets.distinct.joins(applications: :pet_applications).where("applications.status = 1 AND pet_applications.status = 0")
  end
  
end
