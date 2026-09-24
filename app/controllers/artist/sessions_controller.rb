class Artist::SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password]) && user.artist?
      session[:user_id] = user.id
      redirect_to artist_products_path
    else
      flash.now[:alert] = "Email o contraseña incorrectos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to artist_login_path
  end
end
