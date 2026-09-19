class Admin::CommissionsController < ApplicationController
  before_action :require_admin
  before_action :set_commission, only: [:show, :edit, :update]

  def index
    @commissions = Commission.includes(:user, :order).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @commission.update(commission_params)
      redirect_to admin_commission_path(@commission),
                  notice: "Comisión actualizada correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_commission
    @commission = Commission.find(params[:id])
  end

  def commission_params
    params.require(:commission).permit(:status, :deadline)
  end
end