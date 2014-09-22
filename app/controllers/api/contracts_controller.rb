class Api::ContractsController < ApplicationController

  respond_to :json, :csv

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

  def download
    @contracts = Contract.all.limit(25)
    respond_to do |format|
      format.csv { send_data(@contracts.to_csv, disposition: "attachment; filename=federal_contracts.csv") }
    end
  end

end
