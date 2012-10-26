class Manage::ArtworksController < ApplicationController
  def index
    @user = current_user
  end
end
