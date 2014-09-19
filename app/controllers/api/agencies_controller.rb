class Api::AgenciesController < ApplicationController
  
  respond_to :json

  def index
    @agencies = Agency.all
    respond_with(@agencies)
  end

  def show
    @agency = Agency.find(params[:id])
    respond_with(@agency)
  end

  def create
    @agency = Agency.new(agency_params)
  end

  def filter
    @agencies = Agency.filter(params[:query]) # An Agency class method (self.filter) needs to be created in the Agency model in order for this to be implemented - use scopes?
    respond_with(@agencies)
  end

  protected

  def agency_params
    params.require(:agency).permit(:name, :abbr)
  end

end
