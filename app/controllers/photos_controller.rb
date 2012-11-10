class PhotosController < ApplicationController
  before_filter :authenticate!

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      redirect_to :back
    else
      flash[:failure] = "Please try again"
      redirect_to :back
    end
  end
end
