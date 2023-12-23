require "rails_helper" 

RSpec.describe "Admin Shelter Show Page" do 
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

    @shelter_1 = Shelter.create(name: "Aurora Shelter", city: "Aurora, CO", foster_program: false, rank: 9, created_at: Date.today-3)
    @shelter_2 = Shelter.create(name: "RGV Animal Shelter", city: "Harlingen, TX", foster_program: false, rank: 5)

    @pet_1 = Pet.create!(adoptable: true, age: 1, breed: "sphynx", name: "Lucille Bald", shelter_id: @shelter_1.id)
    @pet_2 = Pet.create!(adoptable: true, age: 3, breed: "doberman", name: "Lobster", shelter_id: @shelter_1.id)
    @pet_3 = Pet.create!(adoptable: false, age: 2, breed: "saint bernard", name: "Beethoven", shelter_id: @shelter_1.id)
    @pet_4 = Pet.create!(adoptable: true, age: 1, breed: "beagle", name: "Toaster", shelter_id: @shelter_1.id)
    @pet_5 = Pet.create!(adoptable: false, age: 4, breed: "pitbull", name: "Hoser", shelter_id: @shelter_1.id)
    @pet_6 = Pet.create!(adoptable: true, age: 4, breed: "husky", name: "Juneau", shelter_id: @shelter_1.id)
    @pet_7 = Pet.create!(adoptable: true, age: 1, breed: "rotweiler/beagle", name: "Curtis", shelter_id: @shelter_2.id)
    @pet_8 = Pet.create!(adoptable: true, age: 1, breed: "wolf mix", name: "Marley", shelter_id: @shelter_2.id)
    @pet_9 = Pet.create!(adoptable: true, age: 2, breed: "australian sheep", name: "Chai", shelter_id: @shelter_2.id)

    @pet_app_1 = PetApplication.create!(application_id: @app_1.id, pet_id: @pet_1.id, status: 0)
    @pet_app_2 = PetApplication.create!(application_id: @app_1.id, pet_id: @pet_2.id, status: 1)
    @pet_app_4 = PetApplication.create!(application_id: @app_1.id, pet_id: @pet_4.id, status: 0)
    @pet_app_6 = PetApplication.create!(application_id: @app_1.id, pet_id: @pet_6.id, status: 1)
    @pet_app_7 = PetApplication.create!(application_id: @app_2.id, pet_id: @pet_8.id, status: 2)
    @pet_app_8 = PetApplication.create!(application_id: @app_2.id, pet_id: @pet_9.id, status: 0)
  end 

  it "shows the Shelter's name and address on the admin shelter show page" do
    visit "/admin/shelters/#{@shelter_1.id}"

    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_1.city)
  end

  it "has a section for statistics that shows the average age of all adoptable pets at the shelter" do 
    visit "/admin/shelters/#{@shelter_1.id}"
    
    within ".statistics" do 
      expect(page).to have_content("Statistics")
      expect(page).to have_content("Average Age of Adoptable Pets: 2.1")
    end
  end

  it "in the statistics section it shows the number of pets at that shelter that are adoptable" do 
    visit "/admin/shelters/#{@shelter_1.id}"

    within ".statistics" do 
      expect(page).to have_content("No. Adoptable Pets: 7")
    end
  end

  it "in the statistics section it shows the number of pets that have been adopted from that shelter" do 
    visit "/admin/shelters/#{@shelter_1.id}"

    within ".statistics" do 
      expect(page).to have_content("No. Pets Adopted: 2")
    end
  end

  it "has a section titled 'Action Required' that displays a list of a shelter's pets that have a pending pet application (and, subsequently, 'Pending' status on main application)" do 
    visit "/admin/shelters/#{@shelter_1.id}"

    within ".action-required" do 
      expect(page).to have_content("Lucille Bald")
      expect(page).to have_content("Toaster")
    end

    visit "/admin/shelters/#{@shelter_2.id}"

    within ".action-required" do 
      expect(page).to have_content("Chai")
    end
  end
  
end