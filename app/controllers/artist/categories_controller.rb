class Artist::CategoriesController < ApplicationController
  before_action :require_artist

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to artist_categories_path,
                  notice: "Categoría creada correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
