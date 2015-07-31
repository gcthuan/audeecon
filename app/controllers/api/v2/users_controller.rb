class Api::V2::UsersController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @users }
    # end
    render json: @users.to_json
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.where(username: params[:username])
    if @user.empty?
      render json: "No User found!", status: 404
    else
      render json: @user
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    render json: @user
  end

  # POST /users
  # POST /users.json
  def create
    if User.where(username: user_params[:username]).empty?
      @user = User.new(user_params)
      pack_ids = ["126361870881943", "379426362183248", "1398214440396739"]
      if @user.save
        @user.create_recommender
        @user.recommender.initialize_data
        @user.purchase_pack pack_ids
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: "This username has been chosen!".to_json, status: :conflict
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_user
  end

  #purchase pack
  def purchase
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render @user.errors
    else
      pack = params[:pack_id]
      if Pack.where(_id: pack).empty?
        render json: "No pack with the given id found!".to_json
      else
        @user.purchase_pack pack
        render json: @user
      end
    end
  end

  #unpurchase pack
  def unpurchase
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render @user.errors
    else
      pack = params[:pack_id]
      if Pack.where(_id: pack).empty?
        render json: "No pack with the given id found!".to_json
      else
        @user.unpurchase_pack pack
        render json: @user
      end
    end
  end

  #show all purchased packs of a user
  def show_packs
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render json: "User not found!"
    else
      if @user.packs.nil?
        render json: "This user has not purchased any pack yet.".to_json
      else
        render json: @user.packs.to_json(:except => [:previews, :stickers])
      end
    end
  end

  def recommend
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render json: "No user with the given username found!".to_json
    else
      #@user.recommender.update params[:sticker_id]
      result = @user.recommender.recommend params[:sticker_id]
      render json: result
    end
  end

  def show_latest_recommendation
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render json: "No user with the given username found!".to_json
    else
      #@user.recommender.update params[:sticker_id]
      @latest_recommendation = @user.recommender.latest_recommendation
      render json: @latest_recommendation
    end
  end

  def user_params
    params.permit(:username, :sticker_id)
  end
end