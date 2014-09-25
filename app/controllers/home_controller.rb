class HomeController < ApplicationController
  def index
    params[:vendor] ||= "Bonanza"
    @agencies = Agency.all
    gon.chart_data = [
      ['data1', 30, 100, 100, 400, 150, 250],
      ['data2', 50, 20, 10, 40, 15, 25]
    ]

    search_params = { 
      # description: params[:description]
      vendor: params[:vendor], 
      agency: params[:agency_id],
      start_date: params[:start_date],
      end_date: params[:end_date]
    }

    search = ContractSearch.new(search_params)
    results = search.perform
  end
end
