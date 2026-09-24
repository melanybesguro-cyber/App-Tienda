class Customer::HomeController < ApplicationController
  before_action :require_customer

  def index
    @products = Product.includes(:artist, :category).order(created_at: :desc)
  end
end
