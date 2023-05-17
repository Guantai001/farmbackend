class DairyCostsController < ApplicationController

    skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy]

    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # get all DairyCosts
    def index
        dairy_cost = DairyCost.all
        render json: dairy_cost
    end

    # get one DairyCost
    def show
        dairy_cost = DairyCost.find_by(id: params[:id])
        if dairy_cost
          render json: dairy_cost
        else
          # If the id is not found 
          render json: { error: "DairyCost with id #{params[:id]} not found" }, status: :not_found
        end
    end

    # create new DairyCost

    def create
        dairy_cost = DairyCost.new(dairy_cost_params)
        if dairy_cost.save
            render json: dairy_cost.as_json(except: [:dairy_cost_image]), status: :created
        else
            render json: { error: dairy_cost.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    # update DairyCost
    def update
        dairy_cost = DairyCost.find(params[:id])
        dairy_cost.update!(dairy_cost_params)
        render json: dairy_cost, status: :accepted
    end

    # delete DairyCost
    def destroy
        dairy_cost = DairyCost.find(params[:id])
        if dairy_cost.destroy
            render json: {message: "DairyCost deleted"}
        else
            render json: {error: "DairyCost not deleted"}
        end
    end

    #get the cost price for a specific dairy_cost record
    def cost_price
        dairy_cost = DairyCost.find(params[:id])
        if dairy_cost
            render json: { message: "DairyCost with id #{params[:id]} has #{dairy_cost.cost_price} as cost price" }
        else
            render json: {error: "DairyCost with id #{params[:id]} not found"}, status: :not_found
        end
    end

    # Total Dairy Cost
    def total_dairy_cost
        total = {}
        DairyCost.all.each do |dairy_cost|
            if total[dairy_cost.cost_item]
                total[dairy_cost.cost_item] += dairy_cost.cost_price
            else
                total[dairy_cost.cost_item] = dairy_cost.cost_price
            end
        end
        return total.values.sum
    end

    def total
        total = total_dairy_cost
        render json: { message: "Total Dairy Cost is #{total}" }
    end


    private

    def dairy_cost_params
        params.permit(:price , :item, :date, :admin_id)
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end
    
end


