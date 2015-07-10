class Api::V2::StickersController < ApplicationController
  
  # GET /stickers
  # GET /stickers.json
  def index
    @stickers = Sticker.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @stickers }
    # end
    render json: @stickers
  end

  # GET /stickers/1
  # GET /stickers/1.json
  def show
    @sticker = Sticker.find(params[:id])
    if @sticker.nil?
      render json: "No Sticker with the id found"
    else
      render json: @sticker
    end
  end

  # GET /stickers/new
  # GET /stickers/new.json
  def new
    @sticker = Sticker.new

    render json: @sticker
  end

  # POST /stickers
  # POST /stickers.json
  def create
    @sticker = Sticker.new(sticker_params)

    if @sticker.save
      render json: @sticker, status: :created
    else
      render json: @sticker.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stickers/1
  # DELETE /stickers/1.json
  def destroy
    @sticker = Sticker.find(params[:id])
    @sticker.destroy

    head :no_sticker
  end

  # def sticker_params
  #   params.require(:sticker).permit(:name, :artist, :description, :profile_image, :preview_image, :size)
  # end
end