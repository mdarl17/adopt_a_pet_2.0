require "rails_helper"

RSpec.describe "Application Show Page" do
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
    @app_1.pets << @pet_3
  end

    it "has a applications show page" do
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
      expect(page).to have_content("In progress")

      expect(page).to have_content("Beethoven")
      expect(page).to have_content("In progress")
    end

    it "has a link to add a pet to an application" do
      visit "/applications/#{@app_1.id}"

      @app_1.update!(status: 0)

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
        expect(page).to have_button("Adopt this pet")
      end
    end

    it "won't respond to non existent dog name" do
      visit "/applications/#{@app_1.id}"
      fill_in(:pet_name, with: "Hosehead")
      click_button "Search"

      expect(page).to_not have_content("Hosehead")
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

    it "has an 'Adopt this Pet' button next each pet" do 
      
    end

    it "has a section to submit application after adding pets" do
      visit "/applications/#{@app_2.id}"
      expect(page).to_not have_button("Submit this application")
      expect(page).to_not have_content("Why would you make a good owner?")
      expect(page).to_not have_field("Howdy")

      expect(@app_2.status).to eq("In progress")

      fill_in(:pet_name, with: "Lobster")
      click_button "Search"
      click_button("Adopt this pet")

      fill_in(:pet_name, with: "Hoser")
      click_button "Search"
      click_button("Adopt this pet")
      
      expect(page).to have_field(:good_owner)
      expect(page).to have_content("Why would you make a good owner?")
      fill_in(:good_owner, with: "I'm lonely but also cool")

      expect(page).to have_button("Submit this application")
      click_button("Submit this application")

      expect(current_path).to eq("/applications/#{@app_2.id}")
      
      expect(page).to have_content("Hoser")
      expect(page).to have_content("Lobster")
      expect(page).to have_content("Pending")
      
      expect(page).to_not have_button("Adopt this pet")
      expect(page).to_not have_button("Submit this application")
      expect(page).to_not have_button("Search")
      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_field(:pet_name)
      expect(page).to_not have_content("Search for pet")
    end

    it "has a partial match when searching for available pets" do
      visit "/applications/#{@app_2.id}"
      expect(page).to have_field(:pet_name)

      fill_in(:pet_name, with: "Lob")
      click_button "Search"

      expect(Pet.search("Lob")).to eq([@pet_2])
      expect(page).to have_content("Lobster")
    end

    it "is not case sensitive when searching for available pets" do
      visit "/applications/#{@app_2.id}"
      expect(page).to have_field(:pet_name)

      fill_in(:pet_name, with: "LUCI")
      click_button "Search"

      expect(Pet.search("Lob")).to eq([@pet_2])
      expect(page).to have_content("Lucille")
    end

end

