require "rails_helper"

RSpec.describe Shelter, type: :model do
  describe "relationships" do
    it { should have_many(:pets) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @app_1 = Application.create!(
      name: "Susan", 
      street: "7654 Clover St", 
      city: "Denver", 
      state: "CO", 
      zip: "80033", 
      descr: "I love animals and am lonely.",
      status: 1
    )

    @app_2 = Application.create!(
      name: "Bryan", 
      street: "8888 Hampden Ave", 
      city: "Aurora", 
      state: "CO", 
      zip: "80265", 
      descr: "I am buff af.",
      status: 1
    )

    @app_3 = Application.create!(
      name: "Chris", 
      street: "2484 Yates St", 
      city: "Arlington", 
      state: "TX", 
      zip: "78215", 
      descr: "Work from home, will always be with them.",
      status: 2
    )

    @app_4 = Application.create!(
      name: "Matt", 
      street: "2636 Vrain St", 
      city: "Charlotte", 
      state: "NC", 
      zip: "44140", 
      descr: "Big yard, no other pets, will spoil them.",
      status: 1
    )
      
    @shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9, created_at: Date.today-3)
    @shelter_2 = Shelter.create(name: "RGV Animal Shelter", city: "Harlingen, TX", foster_program: false, rank: 5, created_at: Date.today-7)
    @shelter_3 = Shelter.create(name: "Fancy Pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10, created_at: Date.today)
    @shelter_4 = Shelter.create(name: "Best Friends Animal Society", city: "Kanab, UT", foster_program: true, rank: 1, created_at: Date.today-5)
    @shelter_5 = Shelter.create(name: "Dumb Friends League", city: "Littleton, CO", foster_program: true, rank: 3, created_at: Date.today-2)

    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: true, age: 3, breed: "yellow lab", name: "Mustard", shelter_id: @shelter_1.id)
    @pet_4 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: @shelter_2.id)
    @pet_5 = Pet.create!(adoptable: false, age: 2, breed: "australian ridgeback", name: "Clifford", shelter_id: @shelter_2.id)
    @pet_6 = Pet.create!(adoptable: true, age: 1, breed: "beagle", name: "Toaster", shelter_id: @shelter_3.id)
    @pet_7 = Pet.create!(adoptable: false, age: 4, breed: "pitbull", name: "Hoser", shelter_id: @shelter_3.id)
    @pet_8 = Pet.create!(adoptable: true, age: 2, breed: "husky", name: "Juneau", shelter_id: @shelter_3.id)
    @pet_9 = Pet.create!(adoptable: false, age: 1, breed: "dalmation", name: "Spots", shelter_id: @shelter_3.id)
    @pet_10 = Pet.create!(adoptable: true, age: 2, breed: "dachsund", name: "Wiener", shelter_id: @shelter_3.id)
    @pet_11 = Pet.create!(adoptable: true, age: 1, breed: "rotweiler/beagle", name: "Curtis", shelter_id: @shelter_4.id)
    @pet_12 = Pet.create!(adoptable: false, age: 6, breed: "wolf mix", name: "Marley", shelter_id: @shelter_4.id)
    @pet_13 = Pet.create!(adoptable: true, age: 7, breed: "sheltie", name: "Silver", shelter_id: @shelter_4.id)
    @pet_14 = Pet.create!(adoptable: true, age: 4, breed: "boxer", name: "Rocky", shelter_id: @shelter_4.id)
    @pet_15 = Pet.create!(adoptable: true, age: 2, breed: "australian sheep", name: "Chai", shelter_id: @shelter_5.id)

    @pet_app_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_1.id, status: 2)
    @pet_app_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @app_1.id, status: 0)
    @pet_app_3 = PetApplication.create!(pet_id: @pet_4.id, application_id: @app_1.id, status: 0)
    @pet_app_4 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_3.id, status: 1)
    @pet_app_5 = PetApplication.create!(pet_id: @pet_5.id, application_id: @app_3.id, status: 0)
    @pet_app_6 = PetApplication.create!(pet_id: @pet_9.id, application_id: @app_2.id, status: 1)
    @pet_app_7 = PetApplication.create!(pet_id: @pet_5.id, application_id: @app_2.id, status: 2)
    @pet_app_8 = PetApplication.create!(pet_id: @pet_3.id, application_id: @app_4.id, status: 0)
    @pet_app_9 = PetApplication.create!(pet_id: @pet_7.id, application_id: @app_4.id, status: 0)
    @pet_app_10 = PetApplication.create!(pet_id: @pet_8.id, application_id: @app_4.id, status: 0)
  end

  describe "class methods" do
    describe "#search" do
      it "returns partial matches" do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe "#order_by_recently_created" do
      it "returns shelters with the most recently created first" do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_5, @shelter_1, @shelter_4, @shelter_2])
      end
    end
    
    describe "#order_by_number_of_pets" do
    it "orders the shelters by number of pets they have, descending" do
      expect(Shelter.order_by_number_of_pets).to eq([@shelter_3, @shelter_4, @shelter_1, @shelter_2, @shelter_5])
      end
    end

    describe "#reverse_alpha" do 
      it "displays shelters in reverse alphabetical order using shelter name" do 
        expect(Shelter.reverse_alpha).to eq([@shelter_2, @shelter_3, @shelter_5, @shelter_4, @shelter_1])
      end
    end

    describe "#pending_apps" do 
    it "returns shelters, alphabetically (ascending), that are associated with pending applications" do 
        expect(Shelter.pending_apps).to eq([@shelter_1, @shelter_2, @shelter_3])
      end
    end

    describe "#asc_alpha" do 
      it "orders shelters by name, ascending" do 
        expect(Shelter.asc_alpha).to eq([@shelter_1, @shelter_4, @shelter_5, @shelter_3, @shelter_2])
      end
    end
  end

  describe "#alphabetical_pets" do
    it "returns pets associated with the given shelter in alphabetical name order" do
      expect(Shelter.third.alphabetical_pets).to eq([@pet_7, @pet_8, @pet_9, @pet_6, @pet_10])
    end
  end
  
  describe "instance methods" do
    describe ".adoptable_pets" do
      it "only returns pets that are adoptable" do
        expect(@shelter_1.adoptable_pets).to eq([@pet_1, @pet_2, @pet_3])
        expect(@shelter_3.adoptable_pets).to eq([@pet_6, @pet_8, @pet_10])
      end
    end

    describe ".shelter_pets_filtered_by_age" do
      it "filters a shelter's adoptable pets by age" do
        expect(@shelter_3.shelter_pets_filtered_by_age(2)).to eq([@pet_8, @pet_10])
      end
    end

    describe ".pet_count" do
      it "returns the number of pets at the given shelter" do
        expect(@shelter_3.pet_count).to eq(5)
      end
    end

    describe ".get_name" do 
      it "uses a raw SQL query to return the name of a shelter" do 
        expect(@shelter_1.get_name).to eq("Aurora Shelter")
        expect(@shelter_2.get_name).to eq("RGV Animal Shelter")
      end
    end

    describe ".get_address" do 
      it "uses a raw SQL query to return the a shelter's address" do 
        expect(@shelter_1.get_address).to eq("Aurora, CO")
        expect(@shelter_2.get_address).to eq("Harlingen, TX")
      end
    end

    describe ".average_age" do 
      it "calculates the average age of adoptable pets at a shelter" do 
        expect(@shelter_1.average_age).to eq(2.3)
        expect(@shelter_2.average_age).to eq(2.0)
        expect(@shelter_3.average_age).to eq(2.0)
        expect(@shelter_4.average_age).to eq(4.5)
        expect(@shelter_5.average_age).to eq(2.0)
      end
    end

    describe ".pets_adopted" do 
      it "returns the number of pets that have been adopted from a shelter" do 
        expect(@shelter_1.num_pets_adopted).to eq(0)
        expect(@shelter_2.num_pets_adopted).to eq(2)
        expect(@shelter_3.num_pets_adopted).to eq(2)
        expect(@shelter_4.num_pets_adopted).to eq(1)
        expect(@shelter_5.num_pets_adopted).to eq(0)
      end
    end

    describe ".action_required" do 
      it "returns any pet with a 'Pending' pet application status, and that is also on a 'Pending' application" do 
        expect(@shelter_1.action_required.sort).to eq([@pet_2, @pet_3].sort)
        expect(@shelter_3.action_required.sort).to eq([@pet_7, @pet_8].sort)
      end
    end

    describe ".get_app_id" do 
      it "returns the application id of a given pet from a given shelter" do 
        expect(@shelter_1.get_app_id(@shelter_1.action_required.first.id)).to eq(@app_1.id)
        expect(@shelter_1.get_app_id(@shelter_1.action_required.second.id)).to eq(@app_4.id)
      end
    end
  end
end
