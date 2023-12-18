class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if params[:pet_name].present?
      @pets = Pet.search(params[:pet_name])
    else
      @pets = @application.pet_search(params[:pet_name])
    end
  end

  def new 

  end

  def create 
    application = Application.new({
      name: params[:name],
      street: params[:street],
      city: params[:city],
      state: params[:state],
      zip: params[:zip],
      descr: params[:good_home]
    })

    if application.save
      redirect_to "/applications/#{application.id}"
    else 
      flash[:alert] = "Application not created: Required information missing."

      redirect_to "/applications/new"
    end
  end

  def update 
    application = Application.find(params[:id])

    if params[:app_submit]
      if application.update(status: 1)
        flash[:notice] = "The update was successful and this application is pending"
      else
        flash[:alert] = "Uh-oh, there was an error and the application's status was not updated.
        Please try again later."
      end
    end

    redirect_to "/applications/#{application.id}"
  end
  

end