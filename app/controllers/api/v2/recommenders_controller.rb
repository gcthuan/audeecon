class Api::V2::RecommendersController < ApplicationController
  
  # GET /recommenders
  # GET /recommenders.json
  def index
    @recommenders = Recommender.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @recommenders }
    # end
    render json: @recommenders
  end

  # GET /recommenders/1
  # GET /recommenders/1.json
  def show
    @recommender = User.where(username: params[:username]).first.recommender
    if @recommender.nil?
      render json: "No Recommender of this user found"
    else
      render json: @recommender.to_json(only: :latest_recommendation)
    end
  end

  def recommend
    @recommender = User.where(username: params[:username]).first.recommender
    result = @recommender.recommend params[:sticker_id]
    render json: result
  end
  def recommender_params
    parans.permit(:username, :sticker_id)
  end

end