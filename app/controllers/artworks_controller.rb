class ArtworksController < ApplicationController
  before_filter :authenticate!, except: [:index, :show]

  def index
    if params[:artist_id]
      @artist = IndUser.find(params[:artist_id])
      @artworks = @artist.artworks.ready.page(params[:page]).per(15)
    else
      @artworks = Artwork.ready.page(params[:page]).per(15)
    end
  end

  def new
    @user = IndUser.new
    @user.artworks.build
  end

  def create
    @user = current_user
    @artworks = params[:ind_user][:artworks_attributes].values

    if @artworks.any? { |a| a["photos_attributes"].nil? }
      flash[:warning] = "You forgot to attach photos for some artwork. Please check if you missed anything."
      @user = IndUser.new
      @user.artworks = @artworks.map{|a| Artwork.new(a)}
      render :new
    else
      @artworks.each { |a| @user.artworks.create(a) }
      redirect_to edit_artist_artworks_path(@user)
    end
  end

  def show
    @artwork = Artwork.find(params[:id])
    @original_sellable = @artwork.sellables.original.first
    @copy_sellable = @artwork.sellables.copy.first
    unless current_user && (current_user.admin? || current_user == @artwork.ind_user)
      @artwork.inc(:visit_counter, 1)
    end
  end

  def edit
    @artwork = Artwork.find(params[:id])
    @original_sellable = @artwork.sellables.original.first || @artwork.sellables.new
    @copy_sellable = @artwork.sellables.copy.first || @artwork.sellables.new
    @user = current_user
    @user = @artwork.ind_user if current_user.admin?
  end

  def edit_all
    @user = current_user
    @user = IndUser.find_by_slug(params[:artist_id]) if current_user.admin?
  end

  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update_attributes(params[:artwork])
      redirect_to :back
    end
  end

  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.update_attributes(disabled_at: Time.now)
    render js: "$('#edit_#{@artwork.id}').hide();"
  end

end

