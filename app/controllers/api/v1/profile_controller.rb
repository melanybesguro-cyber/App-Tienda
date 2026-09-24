class Api::V1::ProfileController < ApplicationController
  before_action :authenticate_api_user

  def show
    render json: {
      id: @current_api_user.id,
      name: @current_api_user.name,
      email: @current_api_user.email,
      role: @current_api_user.role
    }
  end
end
