class Api::V1::UsersController < ApplicationController
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
    render json: @user
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
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_user
  end

  #purchase stickers
  def purchase
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render @user.errors
    else
      pack = params[:pack_id]
      if Pack.where(_id: pack).empty?
        render json: "No pack with the given id found!"
      else
        @user.purchase_pack pack
        render json: @user
      end
    end
  end

  #show all purchased packs of a user
  def show_packs
    @user = User.where(username: params[:username]).first
    if @user.nil?
      render json: "No user with the given username found!"
    else
      if @user.packs.nil?
        render json: "This user has not purchased any pack."
      else
        render json: Pack.find(@user.packs).to_json(:except => :stickers)
      end
    end
  end

  def user_params
    params.permit(:username)
  end
end