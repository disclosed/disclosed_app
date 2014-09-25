class HomeController < ApplicationController
  def index
    params[:vendor] ||= "Bonanza"
    @agencies = Agency.all
    gon.chart_data = [
      ['data1', 30, 100, 100, 400, 150, 250],
      ['data2', 50, 20, 10, 40, 15, 25]
    ]
  end

end
