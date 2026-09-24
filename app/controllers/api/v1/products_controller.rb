class Api::V1::ProductsController < ApplicationController
  def index
    products = Product.includes(:category, :artist)

    render json: products.map { |product|
      {
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        stock: product.stock,
        category: product.category&.name,
        artist: product.artist&.name,
        image_url: product_image_url(product)
      }
    }
  end

  def show
    product = Product.find(params[:id])

    render json: {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      category: product.category&.name,
      artist: product.artist&.name,
      image_url: product_image_url(product)
    }
  end

  private

  def product_image_url(product)
    url_for(product.image) if product.image.attached?
  end
end