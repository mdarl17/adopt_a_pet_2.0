require "rails_helper" 

RSpec.describe "Admin Application Show Page" do 
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

    @shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: "RGV Animal Shelter", city: "Harlingen, TX", foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: "Fancy Pets of Colorado", city: "Denver, CO", foster_program: true, rank: 10)

    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: @shelter_2.id)
    @pet_4 = Pet.create!(adoptable: true, age: 1, breed: "beagle", name: "Toaster", shelter_id: @shelter_3.id)
    @pet_5 = Pet.create!(adoptable: true, age: 4, breed: "pitbull", name: "Hoser", shelter_id: @shelter_3.id)

    @pet_app_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_1.id, status: 0)
    @pet_app_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @app_1.id, status: 0)
    # @pet_app_3 = PetApplication.create!(pet_id: @pet_4.id, application_id: @app_1.id, status: 1)
    @pet_app_4 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_2.id, status: 0)
    @pet_app_5 = PetApplication.create!(pet_id: @pet_5.id, application_id: @app_2.id, status: 0)
    @pet_app_6 = PetApplication.create!(pet_id: @pet_3.id, application_id: @app_3.id, status: 0)
    @pet_app_7 = PetApplication.create!(pet_id: @pet_5.id, application_id: @app_3.id, status: 0)
  end

  describe "approving a pet on an application" do 
    it "there is an 'Approve' button next to every pet on the application" do 
      visit "/admin/applications/#{@app_1.id}"
      @app_1.pets.each do |pet| 
        within "#approve-#{pet.id}" do 
          expect(page).to have_content(pet.name)
          expect(page).to have_button("Approve")
        end
      end
    end

    it "when the 'Approve' button is clicked it removes the button and indicates pet application was 'approved'" do 
      visit "/admin/applications/#{@app_1.id}" 
    
      @app_1.pets.each do |pet| 
        within "#approve-#{pet.id}" do 
          click_button("Approve")
          expect(current_path).to eq("/admin/applications/#{@app_1.id}")
          expect(page).to_not have_button("Approve")
          expect(page).to have_content("Approved")
        end
      end
    end
  end

  describe "rejecting a pet on an application" do 
    it "there is a 'Reject' button next to every pet on the application" do 
      visit "/admin/applications/#{@app_1.id}"

      @app_1.pets.each do |pet| 
        within "#approve-#{pet.id}" do 
          expect(page).to have_content(pet.name)
          expect(page).to have_button("Reject")
        end
      end
    end

    it "when the 'Reject' button is clicked it removes the button and indicates pet application was 'rejected'" do 
      visit "/admin/applications/#{@app_1.id}" 
    
      @app_1.pets.each do |pet| 
        within "#approve-#{pet.id}" do 
          click_button("Reject")
          expect(current_path).to eq("/admin/applications/#{@app_1.id}")
          expect(page).to_not have_button("Reject")
          expect(page).to have_content("Rejected")
        end
      end
    end
  end

  describe "approving an application if all pets are approved" do
    it "approves application if all pets are approved" do
      visit "/admin/applications/#{@app_1.id}" 

      @app_1.pets.each do |pet| 
        within "#approve-#{pet.id}" do
          click_button("Approve")
        end
      end
      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      application = Application.find(@app_1.id)
      expect(application.status).to eq("Approved")
      expect(page).to have_content("This Application is Approved!")
    end

    it "doesn't approve the application if one of the pets is rejected" do
      visit "/admin/applications/#{@app_1.id}" 

      first_pet = @app_1.pets.first
        within "#approve-#{first_pet.id}" do
          click_button("Approve")
        end

      last_pet = @app_1.pets.last
          within "#approve-#{last_pet.id}" do
            click_button("Reject")
          end
      
      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      save_and_open_page
      application = Application.find(@app_1.id)
      expect(application.status).to eq("Rejected")
      expect(page).to have_content("This Application is Rejected!")
    end
  end
  describe "approving an application if all pets are approved" do
    it " approves application if all pets are approved" do
      visit "/admin/applications/#{@app_1.id}" 

      @app_1.pets.each do |pet| 
        within "#approve-#{pet.id}" do 
          click_button("Approve")
        end
      end

      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      application = Application.find(@app_1.id)
      expect(application.status).to eq("Approved")
      expect(page).to have_content("This Application is Approved!")
    end

    it "doesn't approve the application if one of the pets is rejected" do
      visit "/admin/applications/#{@app_1.id}" 

      first_pet = @app_1.pets.first
        within "#approve-#{first_pet.id}" do
          click_button("Approve")
        end

      last_pet = @app_1.pets.last
          within "#approve-#{last_pet.id}" do
            click_button("Reject")
          end
      
      expect(current_path).to eq("/admin/applications/#{@app_1.id}")
      application = Application.find(@app_1.id)
      expect(application.status).to eq("Rejected")
      expect(page).to have_content("This Application is Rejected!")
    end
  end
 
end 