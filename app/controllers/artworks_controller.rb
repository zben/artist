class ArtworksController < ApplicationController
  def index
    if params[:artist_id]
      @artworks = Artwork.where(ind_user_id: params[:artist_id])
    else
      @artworks = Artwork.all
    end
  end

  def new
    @user = IndUser.new
    @user.artworks.build
  end

  def create
    @user = current_user
    @artworks = params[:ind_user][:artworks_attributes].values
    @artworks.each do |a|
      if a["photos_attributes"].nil?
        flash[:warning] = "You forgot to attach photos for some artwork. Please check if you missed anything."
      else
        @user.artworks.create(a)
      end

    end
    redirect_to artist_artworks_path(current_user)
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def edit
    @artwork = Artwork.find(params[:id])
  end

  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update_attributes(params[:artwork])
      redirect_to @artwork
    else
      render :edit
    end
  end

  def destroy
  end

end

