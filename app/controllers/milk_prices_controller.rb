class MilkPricesController < ApplicationController

    skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy]

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # get all MilkPrices
    def index
        milk_price = MilkPrice.all
        render json: milk_price, include: [:animal]
    end

    # get one MilkPrice
    def show
        milk_price = MilkPrice.find_by(id: params[:id])
        if milk_price
          render json: milk_price
        else
          # If the id is not found 
          render json: { error: "MilkPrice with id #{params[:id]} not found" }, status: :not_found
        end
    end

    # create new MilkPrice

    def create
       if MilkPrice.all.empty?
        milk_price = MilkPrice.new(milk_price_params)
        if milk_price.save
            render json: milk_price.as_json(except: [:milk_price_image]), status: :created
        else
            render json: { error: milk_price.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
       else
        render json: { error: "MilkPrice already exists" }, status: :unprocessable_entity
       end
    end

    # update MilkPrice
    def update
        milk_price = MilkPrice.find(params[:id])
        milk_price.update!(milk_price_params)
        render json: milk_price, status: :accepted
    end

    # delete MilkPrice
    def destroy
        milk_price = MilkPrice.find(params[:id])
        if milk_price.destroy
            render json: {message: "MilkPrice deleted"}
        else
            render json: {error: "MilkPrice not deleted"}
        end
    end

    private

    def milk_price_params
        params.permit(:price)
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end
end
