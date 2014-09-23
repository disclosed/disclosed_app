class HomeController < ApplicationController
  def index

  end

  def chart_query
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
