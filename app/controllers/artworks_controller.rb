class ArtworksController < ApplicationController
  before_filter :authenticate!, except: [:index]

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
      @artworks.each { |a| @user.artworks.create!(a) }
      redirect_to edit_artist_artworks_path(@user)
    end
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def edit
    @user = current_user
    @user = Artwork.find(params[:id]).ind_user if current_user.admin?
    @ready_artworks = @user.artworks.ready
    @unready_artworks = @user.artworks.not_ready
    @sold_artworks = @user.artworks.where(status: :sold)
  end

  def update
    @artwork = Artwork.find(params[:id])
    if @artwork.update_attributes(params[:artwork])
      render js: "
        $('#message_#{@artwork.id}').html('Update successful').addClass('success').show().delay(1000).fadeOut();
        $('#photo_#{@artwork.id} img').attr('src', '#{@artwork.photos.first.photo(:thumb)}');
      "
    else
      render js: "$('#message_#{@artwork.id}').html(\"#{@artwork.errors.full_messages.join('. ')}\").addClass('failure').show().delay(1000).fadeOut()"
    end
  end

  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.update_attributes(disabled_at: lambda{Time.now})
    render js: "$('#edit_#{@artwork.id}').hide();"
  end

end

