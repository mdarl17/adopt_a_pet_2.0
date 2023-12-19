class Admin::SheltersController < ApplicationController 
  def index 
    @shelters = Shelter.all
  end

  def show
    @shelter = Shelter.find(params[:id])
    #wondering which method to put these ^^ in for admin.
    #I tried making an admin/shelter model
    #I also tried putting it in the shelter model
    #neither worked, might not be setting up the new model correctly
  end
end 
