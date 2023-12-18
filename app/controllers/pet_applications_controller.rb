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
      if pet_application.update(status: 2)
      else
        flash[:alert] = "Uh-oh. It seems there was a problem processing your request. Please try again later."
      end
    end
    
    if params[:commit] == "Approve"
      if pet_application.update(status: 1)
      else
        flash[:alert] = "Uh-oh, there was a problem and the application's status was not updated. 
        Pleast try again later."
      end
    end
    
    if application.rejected?
      if application.update(status: 3)
        flash[:alert] = "This application has been rejected"
      else
        "Uh-oh, there was a problem and the application's status was not updated."
      end
    end

    if application.approved?
      if application.update(status: 2)
        flash[:notice] = "This application has been approved!"
      else
        flash[:alert] = "Uh-oh, there was a problem and the application's status was not updated."
      end
    end
    
    redirect_to "/admin/applications/#{application.id}"
  end

end
