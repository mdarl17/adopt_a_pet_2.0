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
      flash[:notice] = "Uh-oh. There was a problem and #{Pet.find(params[:pet_ident])} has not been added to the application."
    end
    redirect_to "/applications/#{application.id}"
  end
  
  def update 
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_ident])
    pet_application = application.get_pet_app(pet.id)
    
    if params[:commit] == "Reject"
      pet_application.update({status: "Rejected"})
    end

    if params[:commit] == "Approve"
      pet_application.update({status: "Approved"})
    end

    if application.check_app_status == "Rejected"
      if application.update(status: "Rejected")
        flash[:notice] = "The application has been rejected"
      else
        flash[:alert] = "There was a problem trying to update the application status"
      end
    elsif application.check_app_status == "Approved"
      if application.update(status: "Approved")
        flash[:alert] = "The application has been approved"
      else
        flash[:alert] = "There was a problem trying to update the application status"
      end
    end


    # if params[:commit] == "Approve"
    #   if pet_application.update(status: "Approved")
    #     flash[:notice] = "#{pet.name} has been approved."
    #   else
    #     flash[:alert] = "Uh-oh. There was a problem and your changes were not processed"
    #   end
    # elsif params[:commit] == "Reject"
    #   if pet_application.update(status: "Rejected")
    #     flash[:notice] = "#{pet.name} has been rejected."
    #   end
    # end

    # pet_application.update_pet_status(params[:commit])
    redirect_to "/admin/applications/#{application.id}"
  end
end
