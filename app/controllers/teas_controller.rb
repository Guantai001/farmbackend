class TeasController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :latest, :profit_loss]

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # get all Teas
  def index
    tea = Tea.all
    render json: tea
  end

  # get one Tea
  def show
    tea = Tea.find_by(id: params[:id])
    if tea
      render json: tea
    else
      # If the id is not found
      render json: { error: "Tea with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # create new Tea

  def create
    tea = Tea.new(tea_params)
    if tea.save
      render json: tea.as_json, status: :created
    else
      render json: { error: tea.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # update Tea
  def update
    tea = Tea.find(params[:id])
    tea.update!(tea_params)
    render json: tea, status: :accepted
  end

  # delete Tea
  def destroy
    tea = Tea.find(params[:id])
    if tea.destroy
      render json: { message: "Tea deleted" }
    else
      render json: { error: "Tea not deleted" }
    end
  end

  private

  def tea_params
    params.permit(:name, :location, :size, :admin_id, :image)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
