class ApplicationController < ActionController::Base
  private

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