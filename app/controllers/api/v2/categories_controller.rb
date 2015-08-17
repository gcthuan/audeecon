class Api::V2::CategoriesController < ApplicationController
  
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @categories }
    # end
    render json: @categories
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.where(name: params[:name])
    render json: @category.first.stickers
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new

    render json: @category
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(pack_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    head :no_pack
  end
  # 
  def initialize_categories_database
    Category.delay.initialize_categories
    @categories = Category.all
    render json: "Success!".to_json
  end

  def pack_params
    params.require(:category).permit(:name)
  end
end