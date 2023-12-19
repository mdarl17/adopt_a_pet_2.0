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
    describe ".get_pet_app" do 
      it "returns a pet application instance given a pet id" do 
        expect(@app_1.get_pet_app(@pet_1.id)).to eq(@pet_app_1)
        expect(@app_2.get_pet_app(@pet_2.id)).to eq(@pet_app_2)
        expect(@app_2.get_pet_app(@pet_1.id)).to eq(nil)
      end
    end

    describe ".pet_search" do 
      it "searches for pets in the system by name" do 
        expect(@app_2.pet_search("Lobster")).to eq([@pet_2])
      end
    end

    it "will change status of application based on button clicked" do
      button_1 = "Approve"
      button_2 = "Reject"
      @pet_app_1.update_pet_status(button_1)
      expect(@pet_app_1.status).to eq("Approved")
      @pet_app_2.update_pet_status(button_2)
      expect(@pet_app_2.status).to eq("Rejected")
     end

    it "will return the pet application status for a pet" do 
      shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
      pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: shelter_1.id)
      pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
      pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: shelter_1.id)
      app_1 = Application.create!(
        name: "Susan", 
        street: "7654 Clover St", 
        city: "Denver", 
        state: "CO", 
        zip: "80033", 
        descr: "I love animals and am lonely.",
        status: 1
      )

      pet_app_1 = PetApplication.create!(pet_id: pet_1.id, application_id: app_1.id, status: 2)
      pet_app_2 = PetApplication.create!(pet_id: pet_2.id, application_id: app_1.id, status: 2)
      pet_app_3 = PetApplication.create!(pet_id: pet_3.id, application_id: app_1.id, status: 2)

      expect(app_1.all_pets_apps_appr?).to eq(true)
    end

    it "will return the pet application status for a pet" do 
      shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
      pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: shelter_1.id)
      pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
      pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: shelter_1.id)
      app_1 = Application.create!(
        name: "Susan", 
        street: "7654 Clover St", 
        city: "Denver", 
        state: "CO", 
        zip: "80033", 
        descr: "I love animals and am lonely.",
        status: 1
      )

      pet_app_1 = PetApplication.create!(pet_id: pet_1.id, application_id: app_1.id, status: 2)
      pet_app_2 = PetApplication.create!(pet_id: pet_2.id, application_id: app_1.id, status: 3)
      pet_app_3 = PetApplication.create!(pet_id: pet_3.id, application_id: app_1.id, status: 2)

      expect(app_1.all_pets_apps_appr?).to eq(false)
    end

    it "will return nil if there are only Approved and Pending pet applications on an application" do
      shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
      pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: shelter_1.id)
      pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: shelter_1.id)
      pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: shelter_1.id)
      app_1 = Application.create!(
        name: "Susan", 
        street: "7654 Clover St", 
        city: "Denver", 
        state: "CO", 
        zip: "80033", 
        descr: "I love animals and am lonely.",
        status: 1
      )

      pet_app_1 = PetApplication.create!(pet_id: pet_1.id, application_id: app_1.id, status: 2)
      pet_app_2 = PetApplication.create!(pet_id: pet_2.id, application_id: app_1.id, status: 2)
      pet_app_3 = PetApplication.create!(pet_id: pet_3.id, application_id: app_1.id, status: 1)

      expect(app_1.all_pets_apps_appr?).to eq(nil)
    end
  end
end 