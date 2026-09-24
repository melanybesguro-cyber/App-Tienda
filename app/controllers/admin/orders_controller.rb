class Admin::OrdersController < ApplicationController
  before_action :require_admin
  before_action :set_order, only: [ :show, :edit, :update ]

  def index
    @orders = Order.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order),
                  notice: "Pedido actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
