class Admin::OrdersController < AdminBaseController
  def index
    @orders = Order.all
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes params[:order]
        format.html { redirect_to(@order, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@order) }
      else
        format.html { render :action => "index" }
        format.json { respond_with_bip(@order) }
      end
    end
  end
end
