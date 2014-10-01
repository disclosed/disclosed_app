class HomeController < ApplicationController

  def index
    @agencies = Agency.all
    @params = params
    search = ContractSearch.new(params)
    results = search.execute_chart_search
    if results.class == Hash
      gon.chart_data = results[:chart_data]
      @messages = results[:messages]
    else
      gon.chart_data = results
    end
  end

  def download
    search = ContractSearch.new(params)
    contracts = search.execute_report_search
    respond_to do |format|
      format.csv { 
        send_data(Contract.to_csv(contracts), disposition: "attachment; filename=federal_contracts.csv") 
      }
    end
  end

end
