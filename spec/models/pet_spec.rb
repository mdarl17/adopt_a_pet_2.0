require "rails_helper"

RSpec.describe Pet, type: :model do
  describe "relationships" do
    it { should belong_to(:shelter) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: "Mr. Pirate", breed: "tuxedo shorthair", age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: "Clawdia", breed: "shorthair", age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: "Ann", breed: "ragdoll", age: 3, adoptable: false)
  end

  describe "class methods" do
    describe "#search" do
      it "returns partial matches" do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe "#adoptable" do
      it "returns adoptable pets" do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

    describe "#pet_search(name)" do 
      it "will perform an 'exact' search among all pets in the system and return any with the same name given in the 'name' argument" do
        expect(Pet.pet_search("Mr. Pirate")).to eq([@pet_1])
        expect(Pet.pet_search("mr. pirate")).to eq([])
        expect(Pet.pet_search("Mr Pirate")).to eq([])
        expect(Pet.pet_search("mrpirate")).to eq([])

        expect(Pet.pet_search("Clawdia")).to eq([@pet_2])
        expect(Pet.pet_search("clawdia")).to eq([])
        expect(Pet.pet_search("clawda")).to eq([])
      end
    end

  describe "instance methods" do
    describe ".shelter_name" do
      it "returns the shelter name for the given pet" do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end
end
