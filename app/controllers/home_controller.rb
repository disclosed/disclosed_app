class HomeController < ApplicationController
  def index
    @agencies = Agency.all
  end
end
