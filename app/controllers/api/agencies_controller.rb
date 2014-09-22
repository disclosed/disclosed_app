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

end
