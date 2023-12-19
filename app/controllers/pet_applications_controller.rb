class PetApplicationsController < ApplicationController

  def create
    application = Application.find(params[:app_id])

    PetApplication.create!({
        pet_id: params[:pet_id],
        application_id: application.id
      })

    redirect_to "/applications/#{application.id}"
  end

  def update 
    application = Application.find(params[:app_id])
    pet = Pet.find(params[:pet_id])
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
        flash[:notice] = "This application has been approved!"
      end
    else
      flash[:notice] = "This application is pending"
    end
    redirect_to "/admin/applications/#{application.id}"
  end

end
