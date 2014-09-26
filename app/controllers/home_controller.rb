class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    search = ContractSearch.new(params)
    results = search.perform
    gon.results = results
    gon.chart_data = results
  end
end
