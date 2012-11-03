class Admin::ArtworksController < AdminBaseController
  def index
    @artworks = Artwork.all.page(params[:page]).per(20)
  end

  def update
    @artwork = Artwork.find(params[:id])

    respond_to do |format|
      if @artwork.update_attributes params[:artwork]
        format.html { redirect_to(@artwork, :notice => 'Artwork was successfully updated.') }
        format.json { respond_with_bip(@artwork) }
      else
        format.html { render :action => "index" }
        format.json { respond_with_bip(@artwork) }
      end
    end
  end
end


