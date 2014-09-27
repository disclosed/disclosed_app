class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    search = ContractSearch.new(params)
    results = search.perform
    gon.chart_data = results
  end
end
