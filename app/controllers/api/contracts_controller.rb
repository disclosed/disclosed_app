class Api::ContractsController < ApplicationController

  respond_to :json
  
  def index
    @contracts = Contract.all.limit(25)
    respond_with(@contracts)
    render
  end

  def show
    @contract = Contract.find(params[:id])
    respond_with(@contract)
  end

  def create
    @contract = Contract.new(contract_params)
  end

  def filter
    @contracts = Contract.filter(params[:query])  # A Contract class method (self.filter) needs to be created in the Contract model in order for this to be implemented - use scopes?
    respond_with(@contracts)
  end
end
