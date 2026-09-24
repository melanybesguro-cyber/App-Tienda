class Api::V1::CommissionsController < ApplicationController
  before_action :authenticate_api_user
  before_action :set_commission, only: [ :show ]

  def index
    commissions = @current_api_user.commissions.order(created_at: :desc)

    render json: commissions.map { |commission|
      commission_json(commission)
    }
  end

  def show
    render json: commission_json(@commission)
  end

  def create
    if params[:order_id].blank?
      render json: {
        error: "Debés indicar el pedido de la comisión."
      }, status: :unprocessable_entity
      return
    end

    order = @current_api_user.orders.find(params[:order_id])
    commission = @current_api_user.commissions.build(
      order: order,
      description: params[:description],
      status: "pending",
      deadline: params[:deadline]
    )

    if commission.save
      render json: {
        message: "Comisión creada correctamente.",
        commission: commission_json(commission)
      }, status: :created
    else
      render json: {
        errors: commission.errors.full_messages
      }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: {
      error: "Pedido no encontrado."
    }, status: :not_found
  end

  private

  def set_commission
    @commission = @current_api_user.commissions.find(params[:id])
  end

  def commission_json(commission)
    {
      id: commission.id,
      description: commission.description,
      status: commission.status,
      deadline: commission.deadline,
      order_id: commission.order_id,
      created_at: commission.created_at
    }
  end
end
