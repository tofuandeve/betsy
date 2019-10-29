class CategoriesController < ApplicationController
  def index
    @categories = CATEGORIES
  end
end
