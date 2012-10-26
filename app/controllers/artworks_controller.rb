class ArtworksController < ApplicationController
  def index
    if params[:artist_id]
      @artist = IndUser.find(params[:artist_id])
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

    if @artworks.any? { |a| a["photos_attributes"].nil? }
      flash[:warning] = "You forgot to attach photos for some artwork. Please check if you missed anything."
      @user = IndUser.new
      @user.artworks = @artworks.map{|a| Artwork.new(a)}
      render :new
    else
      @artworks.each { |a| @user.artworks.create(a) }
      redirect_to artist_artworks_path(current_user.id)
    end
  end

  def show
    @artwork = Artwork.find(params[:id])
  end

  def edit
    @user = current_user
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
  end

end

