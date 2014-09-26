class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    
    if params[:vendor]
      search_params = { 
      vendor: params[:vendor],
      agency: params[:name]
    }
    else
      search_params = {
        vendor: "Logistics"
    }
    end

    search = ContractSearch.new(search_params)
    results = search.perform
    gon.results = results
    gon.chart_data = results
  end
end
