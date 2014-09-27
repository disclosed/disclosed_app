class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    search = ContractSearch.new(params)
    results = search.perform
    #debugger
    gon.chart_data = results
  end
end
