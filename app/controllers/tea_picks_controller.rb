class TeaPicksController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :latest, :profit_loss]

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # get all TeaPicks
  def index
    tea_pick = TeaPick.all
    render json: tea_pick
  end

  # get one TeaPick
  def show
    tea_pick = TeaPick.find_by(id: params[:id])
    if tea_pick
      render json: tea_pick
    else
      # If the id is not found
      render json: { error: "TeaPick with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # create new TeaPick

  def create
    tea_pick = TeaPick.new(tea_pick_params)
    if tea_pick.save
      render json: tea_pick.as_json, status: :created
    else
      render json: { error: tea_pick.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # update TeaPick
  def update
    tea_pick = TeaPick.find(params[:id])
    tea_pick.update!(tea_pick_params)
    render json: tea_pick, status: :accepted
  end

  # delete TeaPick
  def destroy
    tea_pick = TeaPick.find(params[:id])
    if tea_pick.destroy
      render json: { message: "TeaPick deleted" }
    else
      render json: { error: "TeaPick not deleted" }
    end
  end

  private

  def tea_pick_params
    params.permit(:kilo, :price, :date, :tea_id, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
