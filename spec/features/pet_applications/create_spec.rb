require "rails_helper"

RSpec.describe "pet_application creation" do
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

  it "can add a pet to an application" do
    visit "/applications/#{@app_2.id}"
    
    fill_in(:pet_name, with: "Hoser")
    click_button "Search"

    click_button("Adopt this pet")
    expect(current_path).to eq("/applications/#{@app_2.id}")

    within '#show-pets-on-app' do
      expect(page).to have_content("Hoser")
    end

  end
  
  it "has a button to adopt a pet next to each pet search result" do
    visit "/applications/#{@app_1.id}"
    fill_in(:pet_name, with: "Hoser")

    click_button "Search"

    pet_app = PetApplication.last
    
    expect(page).to have_button("Adopt this pet")
    
    click_button("Adopt this pet")
    
    expect(current_path).to eq("/applications/#{@app_1.id}")
    
    within '#show-pets-on-app' do
      expect(page).to have_content("Hoser")
    end
  end

end