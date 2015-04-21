class Api::V1::PacksController < ApplicationController
  
  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @packs }
    # end
    render json: @packs.to_json(:except => :stickers)
  end

  # GET /packs/1
  # GET /packs/1.json
  def show
    params[:size].blank? ? size = 240 : size = params[:size]
    @pack = Pack.where(sticker_id: params[:id]).stickers.where(request_size: size)
    render json: @pack.to_json(:except => :_id)
  end

  # GET /packs/new
  # GET /packs/new.json
  def new
    @pack = Pack.new

    render json: @pack
  end

  # POST /packs
  # POST /packs.json
  def create

  end

  # DELETE /packs/1
  # DELETE /packs/1.json
  def destroy
    @pack = Pack.find(params[:id])
    @pack.destroy

    head :no_pack
  end
  # get all packs from id_list.txt
  def initialize_database
    Pack.initialize_packs
    @packs = Pack.all
    render json: @packs.to_json(:except => :stickers)
  end

  def pack_params
    params.require(:pack).permit(:name, :artist, :description, :profile_image, :preview_image)
  end
end