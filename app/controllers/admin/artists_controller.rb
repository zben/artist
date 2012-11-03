class Admin::ArtistsController < AdminBaseController
  def index
    @artists = IndUser.where(:admin.ne => false).page(params[:page]).per(20)
  end

  def update
    @artist = IndUser.find(params[:id])

    respond_to do |format|
      if @artist.update_attributes params[:artist]
        format.html { redirect_to(@artist, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@artist) }
      else
        format.html { render :action => "index" }
        format.json { respond_with_bip(@artist) }
      end
    end
  end
end

