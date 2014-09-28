class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    search = ContractSearch.new(params)
    gon.chart_data = search.perform
  end
end
