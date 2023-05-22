class TeaPricesController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :latest, :profit_loss]

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # get all TeaPrices
  def index
    tea_price = TeaPrice.all
    render json: tea_price
  end

  # get one TeaPrice
  def show
    tea_price = TeaPrice.find_by(id: params[:id])
    if tea_price
      render json: tea_price
    else
      # If the id is not found
      render json: { error: "TeaPrice with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # create new TeaPrice

  def create
    tea_price = TeaPrice.new(tea_price_params)
    if tea_price.save
      render json: tea_price.as_json, status: :created
    else
      render json: { error: tea_price.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # update TeaPrice
  def update
    tea_price = TeaPrice.find(params[:id])
    tea_price.update!(tea_price_params)
    render json: tea_price, status: :accepted
  end

  # delete TeaPrice
  def destroy
    tea_price = TeaPrice.find(params[:id])
    if tea_price.destroy
      render json: { message: "TeaPrice deleted" }
    else
      render json: { error: "TeaPrice not deleted" }
    end
  end

  private

  def tea_price_params
    params.permit(:price, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
