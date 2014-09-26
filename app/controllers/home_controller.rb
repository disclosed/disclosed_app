require 'debugger'

class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    
    if params[:vendor]
      search_params = { 
      vendor: params[:vendor]
    }
    @search = ContractSearch.new(search_params)
    else
      search_params = {
        vendor: "Logistics"
      }
    end

    results = @search.perform
    gon.results = results
    gon.chart_data = results
  end
end
