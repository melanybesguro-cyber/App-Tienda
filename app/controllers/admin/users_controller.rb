class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [ :show ]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
