class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def verify_authenticity_token
    return if api_request_with_valid_token?

    super
  end

  private

  def api_request_with_valid_token?
    return false unless %w[PATCH PUT POST DELETE].include?(request.method)
    return false unless request.format.json? || request.media_type == "application/json"

    token = request.headers["Authorization"]&.split(" ")&.last
    token.present? && User.exists?(api_token: token)
  end

  def authenticate_api_user
    token = request.headers["Authorization"]&.split(" ")&.last

    @current_api_user = User.find_by(api_token: token)

    unless @current_api_user
      render json: {
        error: "Token inválido o ausente."
      }, status: :unauthorized
    end
  end

  def require_admin
    user = User.find_by(id: session[:user_id])

    return if user&.admin?

    redirect_to admin_login_path,
                alert: "Debés iniciar sesión como administrador."
  end

  def require_artist
    user = User.find_by(id: session[:user_id])

    return if user&.artist?

    redirect_to admin_login_path,
                alert: "Debés iniciar sesión como artista."
  end

  def require_customer
    user = User.find_by(id: session[:user_id])

    return if user&.customer?

    redirect_to customer_login_path,
                alert: "Debés iniciar sesión como cliente."
  end
end
