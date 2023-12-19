require "rails_helper" 

RSpec.describe Application, type: :model do
  before(:each) do 
    @shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter_1.id)

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

    @pet_app_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_1.id, status: 1)
    @pet_app_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @app_2.id, status: 1)

  end

  describe "instance methods" do 
    describe ".get_pet_app(pet_id)" do 
      it "returns a pet application instance given a pet id" do 
        expect(@app_1.get_pet_app(@pet_1.id)).to eq(@pet_app_1)
        expect(@app_2.get_pet_app(@pet_2.id)).to eq(@pet_app_2)
        expect(@app_2.get_pet_app(@pet_1.id)).to eq(nil)
      end
    end

    describe ".rejected?" do 
      it "returns false if ANY of the pet applications on an application are rejected" do 
        app_1 = Application.create!(
          name: "Susan", 
          street: "7654 Clover St", 
          city: "Denver", 
          state: "CO", 
          zip: "80033", 
          descr: "I love animals and am lonely.",
          status: 0
        )

        app_2 = Application.create!(
          name: "Bryan", 
          street: "8888 Hampden Ave", 
          city: "Aurora", 
          state: "CO", 
          zip: "80265", 
          descr: "I am buff af.",
          status: 0
        )

        shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        shelter_2 = Shelter.create(name: "RGV Animal Shelter", city: "Harlingen, TX", foster_program: false, rank: 5)

        pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: shelter_1.id)
        pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: shelter_1.id)
        pet_4 = Pet.create!(adoptable: true, age: 1, breed: "beagle", name: "Toaster", shelter_id: shelter_2.id)
        pet_5 = Pet.create!(adoptable: true, age: 4, breed: "pitbull", name: "Hoser", shelter_id: shelter_2.id)

        pet_app_1 = PetApplication.create!(pet_id: pet_1.id, application_id: app_1.id, status: 1)
        pet_app_2 = PetApplication.create!(pet_id: pet_2.id, application_id: app_1.id, status: 1)
        pet_app_3 = PetApplication.create!(pet_id: pet_4.id, application_id: app_1.id, status: 1)
        pet_app_4 = PetApplication.create!(pet_id: pet_1.id, application_id: app_2.id, status: 2)
        pet_app_5 = PetApplication.create!(pet_id: pet_5.id, application_id: app_2.id, status: 1)

        expect(app_1.rejected?).to eq(false)
        expect(app_2.rejected?).to eq(true)
      end
    end

    describe ".approved?" do 
      it "returns true if an application has been approved (all pet applications are 'approved')" do 
        app_1 = Application.create!(
          name: "Susan", 
          street: "7654 Clover St", 
          city: "Denver", 
          state: "CO", 
          zip: "80033", 
          descr: "I love animals and am lonely.",
          status: 0
        )

        app_2 = Application.create!(
          name: "Bryan", 
          street: "8888 Hampden Ave", 
          city: "Aurora", 
          state: "CO", 
          zip: "80265", 
          descr: "I am buff af.",
          status: 0
        )

        shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
        shelter_2 = Shelter.create(name: "RGV Animal Shelter", city: "Harlingen, TX", foster_program: false, rank: 5)

        pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: shelter_1.id)
        pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
        pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: shelter_1.id)
        pet_4 = Pet.create!(adoptable: true, age: 1, breed: "beagle", name: "Toaster", shelter_id: shelter_2.id)
        pet_5 = Pet.create!(adoptable: true, age: 4, breed: "pitbull", name: "Hoser", shelter_id: shelter_2.id)

        pet_app_1 = PetApplication.create!(pet_id: pet_1.id, application_id: app_1.id, status: 1)
        pet_app_2 = PetApplication.create!(pet_id: pet_2.id, application_id: app_1.id, status: 1)
        pet_app_3 = PetApplication.create!(pet_id: pet_4.id, application_id: app_1.id, status: 1)
        pet_app_4 = PetApplication.create!(pet_id: pet_1.id, application_id: app_2.id, status: 2)
        pet_app_5 = PetApplication.create!(pet_id: pet_5.id, application_id: app_2.id, status: 1)

        expect(app_1.approved?).to eq(true)
        expect(app_2.approved?).to eq(false)
      end
    end
  end
end 