class SellablesController < ApplicationController

  def create
    @sellable = Sellable.new(params[:sellable])
    if @sellable.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def update
    @sellable = Sellable.find(params[:id])
    if @sellable.update_attributes(params[:sellable])
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.update_attributes(disabled_at: Time.now)
    render js: "$('#edit_#{@artwork.id}').hide();"
  end

end


