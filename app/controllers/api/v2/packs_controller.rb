class Api::V2::PacksController < ApplicationController
  
  # GET /packs
  # GET /packs.json
  def index
    @packs = Pack.all.order_by(created_at: 'desc')

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
  def new_packs
    @store_curl = params[:store_curl]
    render action: 'new_packs'
    if !@store_curl.blank?
      Pack.delay.initialize_packs params[:store_curl]
    end
  end

  def pack_params
    params.require(:pack).permit(:name, :artist, :description, :profile_image, :preview_image, :size)
  end
end