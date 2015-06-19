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
    @user = User.where(username: params[:username])
    pack = params[:pack_id]
    @user.first.purchase_pack pack
    render json: @user
  end

  def user_params
    params.permit(:username)
  end
end