class WatchersController < ApplicationController
  def create
    @watcher = Watcher.create(params.require(:watcher).permit(:email))
    redirect_to root_url
  end
end
