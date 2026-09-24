class Customer::OrdersController < ApplicationController
  before_action :require_customer

  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if quantity <= 0
      redirect_to customer_root_path, alert: "La cantidad debe ser mayor a 0."
      return
    end

    order = current_user.orders.build(status: "pending", total: 0)

    ActiveRecord::Base.transaction do
      if product.stock < quantity
        raise ActiveRecord::Rollback,
              "No hay stock suficiente. Disponible: #{product.stock}."
      end

      order.order_items.build(
        product: product,
        quantity: quantity,
        unit_price: product.price
      )
      order.total = product.price * quantity
      order.save!
      product.update!(stock: product.stock - quantity)
    end

    if order.persisted?
      begin
        OrderMailer.created(order).deliver_now
        redirect_to customer_root_path, notice: "Pedido creado correctamente."
      rescue Net::SMTPError, OpenSSL::SSL::SSLError => error
        Rails.logger.error("No se pudo enviar la confirmación del pedido #{order.id}: #{error.message}")
        redirect_to customer_root_path,
                    alert: "Pedido creado, pero no se pudo enviar el correo de confirmación."
      end
    else
      redirect_to customer_root_path, alert: "No se pudo crear el pedido."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to customer_root_path, alert: "Producto no encontrado."
  rescue ActiveRecord::Rollback => error
    redirect_to customer_root_path, alert: error.message
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end