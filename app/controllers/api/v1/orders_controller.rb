class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_api_user
  before_action :set_order, only: [:show]

  def index
    orders = @current_api_user.orders
                             .includes(order_items: :product)
                             .order(created_at: :desc)

    render json: orders.map { |order|
      order_json(order)
    }
  end

  def show
    render json: order_json(@order)
  end

  def create
    order = @current_api_user.orders.build(
      status: "pending",
      total: 0
    )

    products_data = params[:products]

    if products_data.blank?
      render json: {
        error: "Debés indicar al menos un producto."
      }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      total = 0

      products_data.each do |item|
        product = Product.find(item[:product_id])
        quantity = item[:quantity].to_i

        if quantity <= 0
          raise ActiveRecord::Rollback,
                "La cantidad debe ser mayor a 0."
        end

        if product.stock < quantity
          raise ActiveRecord::Rollback,
                "No hay suficiente stock para #{product.name}. Disponible: #{product.stock}, solicitado: #{quantity}."
        end

        unit_price = product.price
        subtotal = unit_price * quantity
        total += subtotal

        order.order_items.build(
          product: product,
          quantity: quantity,
          unit_price: unit_price
        )

        product.update!(
          stock: product.stock - quantity
        )
      end

      order.total = total
      order.save!
    end

    if order.persisted?
      render json: {
        message: "Pedido creado correctamente.",
        order: order_json(order)
      }, status: :created
    else
      render json: {
        error: "No se pudo crear el pedido."
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Producto no encontrado."
    }, status: :not_found

  rescue ActiveRecord::Rollback => e
    render json: {
      error: e.message
    }, status: :unprocessable_entity
  end

  private

  def set_order
    @order = @current_api_user.orders.find(params[:id])
  end

  def order_json(order)
    {
      id: order.id,
      status: order.status,
      total: order.total,
      created_at: order.created_at,
      products: order.order_items.map do |item|
        {
          product_id: item.product_id,
          product: item.product.name,
          quantity: item.quantity,
          unit_price: item.unit_price,
          subtotal: item.unit_price * item.quantity
        }
      end
    }
  end
end