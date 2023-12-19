class Admin::Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  
  def find_shelter_name(shelter_id)
    self.find_by_sql("SELECT name FROM shelters WHERE id = #{shelter_id}").first&.name
  end



end
