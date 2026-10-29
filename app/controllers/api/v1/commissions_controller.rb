class Api::V1::CommissionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_user
  before_action :set_commission, only: [ :show, :update ]

  def index
    # Si es artista, ve todas las comisiones de la tienda. Si es cliente, solo las suyas.
    if @current_api_user.role == 'artist'
      commissions = Commission.includes(:user, :order).order(created_at: :desc)
    else
      commissions = @current_api_user.commissions.order(created_at: :desc)
    end

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
      title: params[:title],
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

  def update
    if @commission.update(commission_params)
      render json: {
        message: "Comisión actualizada correctamente.",
        commission: commission_json(@commission)
      }
    else
      render json: { errors: @commission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_commission
    if @current_api_user.role == 'artist'
      @commission = Commission.find(params[:id])
    else
      @commission = @current_api_user.commissions.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Comisión no encontrada." }, status: :not_found
  end

  def commission_json(commission)
    {
      id: commission.id,
      title: commission.title,
      description: commission.description,
      status: commission.status,
      deadline: commission.deadline,
      order_id: commission.order_id,
      client_name: commission.user&.name || 'Cliente',
      created_at: commission.created_at
    }
  end

  def commission_params
    params.require(:commission).permit(:title, :description, :deadline, :status, :order_id)
  end
end