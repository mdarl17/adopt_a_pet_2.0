require "rails_helper" 

RSpec.describe "Admin Shelters Index page" do 
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

    @pet_app_1 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_1.id, status: 2)
    @pet_app_2 = PetApplication.create!(pet_id: @pet_2.id, application_id: @app_1.id, status: 0)
    @pet_app_3 = PetApplication.create!(pet_id: @pet_4.id, application_id: @app_1.id, status: 0)
    @pet_app_4 = PetApplication.create!(pet_id: @pet_1.id, application_id: @app_2.id, status: 1)
    @pet_app_5 = PetApplication.create!(pet_id: @pet_5.id, application_id: @app_2.id, status: 0)
    @pet_app_6 = PetApplication.create!(pet_id: @pet_3.id, application_id: @app_3.id, status: 1)
    @pet_app_7 = PetApplication.create!(pet_id: @pet_5.id, application_id: @app_3.id, status: 0)
  end

  it "displays all Shelters in the system listed in reverse alphabetical order" do 
    visit "/admin/shelters"

    expect(page).to have_content("Admin Shelters")

    expect(page).to have_content("Aurora Shelter")
    expect(page).to have_content("City: Aurora, CO")
    expect(page).to have_content("Foster Program: false")
    expect(page).to have_content("Rank: 9")
    
    expect(page).to have_content("RGV Animal Shelter")
    expect(page).to have_content("City: Harlingen, TX")
    expect(page).to have_content("Foster Program: false")
    expect(page).to have_content("Rank: 5")
    
    expect(page).to have_content("Fancy Pets of Colorado")
    expect(page).to have_content("City: Denver, CO")
    expect(page).to have_content("Foster Program: false")
    expect(page).to have_content("Rank: 10")

    expect("RGV Animal Shelter").to appear_before("Fancy Pets of Colorado")
    expect("Fancy Pets of Colorado").to appear_before("Aurora Shelter")
  end

  it "has a section for 'Shelters with Pending Applications'" do 
    visit "/admin/shelters"

    expect(page).to have_content("Shelters with Pending Applications")
    
    within "#shelters-pending" do 
      expect(page).to have_content("Aurora Shelter")
      expect(page).to have_content("Fancy Pets of Colorado")
    end
  end
end 