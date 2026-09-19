class Artist::ProductsController < ApplicationController
  before_action :require_artist
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = current_user.products
  end

  def show
  end

  def new
    @product = current_user.products.build
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to artist_product_path(@product),
                  notice: "Producto creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to artist_product_path(@product),
                  notice: "Producto actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy

    redirect_to artist_products_path,
                notice: "Producto eliminado correctamente."
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def set_product
    @product = current_user.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :stock,
      :category_id
    )
  end
end