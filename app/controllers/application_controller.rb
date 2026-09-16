class ApplicationController < ActionController::Base
  private

  def require_admin
    user = User.find_by(id: session[:user_id])

    return if user&.admin?

    redirect_to admin_login_path,
                alert: "Debés iniciar sesión como administrador."
  end
end