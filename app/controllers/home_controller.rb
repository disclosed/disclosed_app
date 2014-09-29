class HomeController < ApplicationController
  def index
    @agencies = Agency.all
    search = ContractSearch.new(params)
    @params = params
    gon.chart_data = search.execute_chart_search
    @contracts = search.execute_report_search
  end
end
