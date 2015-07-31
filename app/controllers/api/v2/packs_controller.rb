class Api::V2::PacksController < ApplicationController
  
  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @packs }
    # end
    render json: @packs.to_json(:except => [:previews, :stickers])
  end

  # GET /packs/1
  # GET /packs/1.json
  def show
    params[:size].blank? ? size = 256 : size = params[:size]
    @pack = Pack.find(params[:id]).stickers.where(request_size: size)
    render json: @pack
  end

  #return a sticker
  def get_sticker 
    @sticker = Pack.find(params[:id]).stickers.where(_id: params[:sticker_id]).first
    if @sticker.empty?
      render @stickers.errors
    else
      render json: @sticker
    end
  end

  def demo
    params[:size].blank? ? size = 240 : size = params[:size]
    @packs = Pack.limit(10).elem_match(stickers: {request_size: size})
    render json: @packs.to_json(:except => :_id)
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
    @pack = Pack.new(pack_params)

    if @pack.save
      render json: @pack, status: :created
    else
      render json: @pack.errors, status: :unprocessable_entity
    end
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
    Pack.delay.initialize_packs
    @packs = Pack.all
    render json: @packs.to_json(:except => :stickers)
  end

  def pack_params
    params.require(:pack).permit(:name, :artist, :description, :profile_image, :preview_image, :size)
  end
end