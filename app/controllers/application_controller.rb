class ApplicationController < ActionController::Base
  # Desactivamos CSRF por defecto para peticiones de API basadas en token
  protect_from_forgery with: :exception, unless: -> { request.format.json? || request.headers["Authorization"].present? }

  def verify_authenticity_token
    return if api_request_with_valid_token?
    super
  end

  private

  def api_request_with_valid_token?
    token = request.headers["Authorization"]&.split(" ")&.last
    token.present? && User.exists?(api_token: token)
  end

  def authenticate_api_user
    token = request.headers["Authorization"]&.split(" ")&.last
    @current_api_user = User.find_by(api_token: token)

    unless @current_api_user
      render json: { error: "Token inválido o ausente." }, status: :unauthorized
    end
  end

  # Adaptamos los filtros para que funcionen con la API basada en el token Bearer
  def require_customer
    token = request.headers["Authorization"]&.split(" ")&.last
    user = User.find_by(api_token: token) || User.find_by(id: session[:user_id])

    unless user&.customer?
      render json: { error: "Acceso denegado. Se requiere rol de cliente." }, status: :unauthorized
    end
  end

  def require_artist
    token = request.headers["Authorization"]&.split(" ")&.last
    user = User.find_by(api_token: token) || User.find_by(id: session[:user_id])

    unless user&.artist?
      render json: { error: "Acceso denegado. Se requiere rol de artista." }, status: :unauthorized
    end
  end

  def require_admin
    token = request.headers["Authorization"]&.split(" ")&.last
    user = User.find_by(api_token: token) || User.find_by(id: session[:user_id])

    unless user&.admin?
      render json: { error: "Acceso denegado. Se requiere rol de administrador." }, status: :unauthorized
    end
  end
end