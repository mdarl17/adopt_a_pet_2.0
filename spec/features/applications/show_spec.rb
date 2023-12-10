require "rails_helper"

RSpec.describe "pet creation" do
  before(:each) do
    @app_1 = Application.create!(name: "Susan", 
      street: "7654 Clover St", 
      city: "Denver", 
      state: "CO", 
      zip: "80033", 
      descr: "I love animals and am lonely")

      @app_2 = Application.create!(name: "Bryan", 
      street: "8888 Hampden", 
      city: "Denver", 
      state: "CO", 
      zip: "80265", 
      descr: "I am buff af")

    @shelter = Shelter.create!(name: "Aurora shelter", city: "Aurora, CO", foster_program: false, rank: 9)
    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter.id)
    @pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: @shelter.id)
    @pet_4 = Pet.create!(adoptable: true, age: 1, breed: "beagle", name: "Toaster", shelter_id: @shelter.id)
    @pet_5 = Pet.create!(adoptable: true, age: 4, breed: "pitbull", name: "Hoser", shelter_id: @shelter.id)
   

    @pet_1_app =PetApplication.create!(pet_id: @pet_1.id, application_id: @app_1.id)
    @app_1.pets << @pet_2
    # @app_1.pets << @pet_3
  end

    it "has a applications show page" do
    # As a visitor
    # When I visit an applications show page
    # Then I can see the following:
    # Name of the Applicant
    # Full Address of the Applicant including street address, city, state, and zip code
    # Description of why the applicant says they'd be a good home for this pet(s)
    # names of all pets that this application is for (all names of pets should be links to their show page)
    # The Application's status, either "In Progress", "Pending", "Accepted", or "Rejected"
      
    visit "/applications/#{@app_1.id}"

      expect(page).to have_content(@app_1.name)
      expect(page).to have_content(@app_1.street)
      expect(page).to have_content(@app_1.city)
      expect(page).to have_content(@app_1.state)
      expect(page).to have_content(@app_1.zip)
      expect(page).to have_content(@app_1.descr)
    end

    it "shows the names of all pets on the application and their status" do
      visit "/applications/#{@app_1.id}"

      expect(page).to have_content("Lucille Bald")
      # expect(page).to have_content("In Progress")

      expect(page).to have_content("Beethoven")
      # expect(page).to have_content("In Progress")
    end

    it "has a link to add a pet to an application" do
      visit "/applications/#{@app_1.id}"

      expect(page).to have_content("Add a Pet to this Application")
    end

    it "expect section to have search field for pet names" do

      visit "/applications/#{@app_1.id}"

      expect(page).to have_content("Search for pet")

      expect(page).to have_field(:pet_name)
      expect(page).to have_button("Search")

      fill_in(:pet_name, with: "Toaster")

      click_button "Search"

      expect(current_path).to eq("/applications/#{@app_1.id}")
      within "#show-#{@pet_4.id}" do 
        expect(page).to have_content("Toaster")
      end

    end

    it "won't respond to non existant dog name" do
      visit "/applications/#{@app_1.id}"
      fill_in(:pet_name, with: "Hoser")
      click_button "Search"

      expect(page).to_not have_content("Hoser")
    end

    it "has a button to adopt a pet next to each pet search result" do
      visit "/applications/#{@app_1.id}"
      fill_in(:pet_name, with: "Hoser")

      click_button "Search"
      
      expect(page).to have_button("Adopt this pet")
      
      click_button("Adopt this pet")
      
      expect(current_path).to eq("/applications/#{@app_1.id}")
      within '#show-pets-on-app' do
      expect(page).to have_content("Hoser")
      end
    end

    it "has a section to submit application after adding pets" do
      visit "/applications/#{@app_2.id}"
      expect(page).to_not have_button("Submit this application")
      expect(page).to_not have_content("Why would you make a good owner?")
      expect(page).to_not have_field("Howdy")

      save_and_open_page
      expect(@app_2.status).to eq("In progress")

      fill_in(:pet_name, with: "Hoser")
      click_button "Search"
      click_button("Adopt this pet")

      expect(page).to have_button("Submit this application")
      expect(page).to have_field(:good_owner)
      expect(page).to have_content("Why would you make a good owner?")

      fill_in(:good_owner, with: "I'm lonely but also cool")
      click_button("Submit this application")

      expect(current_path).to eq("/applications/#{@app_2.id}")
      expect(page).to have_content("Pending")

      expect(page).to have_content("Hoser")
      expect(page).to have_content("Lobster")
      expect(page).to have_content("Lucille Bald")

      expect(@app_2.status).to eq("Pending")

      expect(page).to_not have_button("Adopt this pet")
      expect(page).to_not have_button("Submit this application")
      expect(page).to_not have_button("Search")
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_field(:pet_name)
      expect(page).to_not have_content("Search for pet")

    end

end

