class Api::V1::ProductsController < ApplicationController
  # Desactivamos la protección CSRF para las peticiones de la API
  skip_before_action :verify_authenticity_token

  def index
    products = Product.includes(:category)
    render json: products.map { |product| serialize_product(product) }
  end

  def show
    product = Product.find(params[:id])
    render json: serialize_product(product)
  end

  def create
    product = Product.new(product_params)

    if product.save
      render json: serialize_product(product), status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    product = Product.find(params[:id])

    if product.update(product_params)
      render json: serialize_product(product)
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    product = Product.find(params[:id])
    product.destroy
    render json: { message: 'Producto eliminado con éxito' }, status: :ok
  end

  private

  def product_image_url(product)
    if product.image.attached?
      rails_blob_url(product.image, only_path: false)
    else
      nil
    end
  end

  def serialize_product(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      category: product.category&.name,
      image_url: product_image_url(product)
    }
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :image, :category_id)
  end
end