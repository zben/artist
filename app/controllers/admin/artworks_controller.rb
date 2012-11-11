class Admin::ArtworksController < AdminBaseController
  def index
    @sellables = Sellable.all.page(params[:page]).per(20)
  end

  def update
    @sellable = Sellable.find(params[:id])
    @artwork = @sellable.artwork

    respond_to do |format|
      if @sellable.update_attributes params[:sellable]
        format.html { redirect_to(@artwork, :notice => 'Artwork was successfully updated.') }
        format.json { respond_with_bip(@sellable) }
      else
        format.html { render :action => "index" }
        format.json { respond_with_bip(@sellable) }
      end
    end
  end
end


