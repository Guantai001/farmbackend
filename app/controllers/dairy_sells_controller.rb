class DairySellsController < ApplicationController
    skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy]

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # get all DairySells
    def index
        dairy_sell = DairySell.all
        render json: dairy_sell, include: [:animal]
    end

    # get one DairySell
    def show
        dairy_sell = DairySell.find_by(id: params[:id])
        if dairy_sell
          render json: dairy_sell
        else
          # If the id is not found 
          render json: { error: "DairySell with id #{params[:id]} not found" }, status: :not_found
        end
    end

    # create new DairySell

    def create
        dairy_sell = DairySell.new(dairy_sell_params)
        if dairy_sell.save
            render json: dairy_sell.as_json(except: [:dairy_sell_image]), status: :created
        else
            render json: { error: dairy_sell.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    # update DairySell
    def update
        dairy_sell = DairySell.find(params[:id])
        dairy_sell.update!(dairy_sell_params)
        render json: dairy_sell, status: :accepted
    end

    # delete DairySell
    def destroy
        dairy_sell = DairySell.find(params[:id])
        if dairy_sell.destroy
            render json: {message: "DairySell deleted"}
        else
            render json: {error: "DairySell not deleted"}
        end
    end

    #get the sold price for a specific dairy_sell record
    def sold_price
        dairy_sell = DairySell.find(params[:id])
        if dairy_sell
            render json: { message: "DairySell with id #{params[:id]} has #{dairy_sell.sold_price} as sold price" }
        else
            render json: {error: "DairySell with id #{params[:id]} not found"}, status: :not_found
        end
    end

    # Total Dairy Sell
    def total_dairy_sell
       total = {}
       DairySell.all.each do |dairy_sell|
        if total[dairy_sell.sold_item] 
            total[dairy_sell.sold_item] += dairy_sell.sold_price
        else
            total[dairy_sell.sold_item] = dairy_sell.sold_price
          end
        end
        return total.values.sum
    end
    
    def total
        total = total_dairy_sell
        render json: { message: "Total Dairy Sell is #{total}" }
    end

    private

    def dairy_sell_params
        params.permit(:item , :price, :date,:admin_id)
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

end

