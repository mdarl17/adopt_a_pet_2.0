class PetApplicationsController < ApplicationController
  def create
    application = Application.find(params[:id])

    pet_application = PetApplication.new({
      pet_id: params[:pet_ident],
      application_id: application.id
    })
    if pet_application.save
      flash[:notice] = "#{Pet.find(params[:pet_ident])} has been added to the application."
    else
      # how to test this??
      flash[:notice] = "Uh-oh. There was a problem with your request. Please try adopting the pet again."
    end
    redirect_to "/applications/#{application.id}"
  end
  
  def update 
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_ident])
    pet_application = application.get_pet_app(pet.id)
    
    
    if params[:commit] == "Reject"
      pet_application.update(status: 2)
    end
    
    if params[:commit] == "Approve"
      pet_application.update(status: 1)
    end
    
    if application.rejected?
      if application.update(status: 3)
        flash[:alert] = "This application has been rejected"
      end
    elsif application.approved?
      if application.update(status: 2)
        application.pets.each do |pet_instance| 
          pet_instance.update!(adoptable: false)
        end
        flash[:notice] = "This application has been approved!"
      end
    else
      flash[:notice] = "This application is pending"
    end
    redirect_to "/admin/applications/#{application.id}"
  end
end
