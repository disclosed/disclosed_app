class HomeController < ApplicationController

  def index
    @agencies = Agency.all
    search = ContractSearch.new(params)
    #debugger
    gon.chart_data = search.execute_chart_search
  end

  def download
    search = ContractSearch.new(params)
    contracts = search.execute_report_search
    debugger
    respond_to do |format|
      format.csv { send_data(contracts.to_csv, disposition: "attachment; filename=federal_contracts.csv") }
    end
  end

end
