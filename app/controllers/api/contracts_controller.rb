class Api::ContractsController < ApplicationController
  include ContractsIo
  respond_to :json

  def index
    @contracts = Contract.all.limit(25)
    respond_with(@contracts)
  end

  def show
    @contract = Contract.find(params[:id])
    respond_with(@contract)
  end

  def create
    @contract = Contract.new(contract_params)
  end

end
