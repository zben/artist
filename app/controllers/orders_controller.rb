#encoding: utf-8
class OrdersController < ApplicationController
  def index
  end

  def show
  end

  def create
    @order = Order.new(params[:order].merge(org_user_id: current_user.id))
    @order.status = :placed
    if @order.save
      if @order.is_for_real
        render js: "
            $('#real_order').hide();
            $('#real_message').html('谢谢您 请等候我们的电话').hide().show(200);"
      else
        render js: "
            $('#copy_order').hide();
            $('#copy_message').html('谢谢您 请等候我们的电话').hide().show(200);"
      end
    end
  end

  def edit
  end

  def update
  end

  def cancel
    @order = Order.find(params[:id])
    @order.status = :cancelled
    if @order.save
      redirect_to :back
    end
  end

end
