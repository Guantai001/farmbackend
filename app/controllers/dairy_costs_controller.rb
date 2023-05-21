class DairyCostsController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :cost_price, :total, :sort_costs_by_month, :admin_totals]

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
      render json: { error: dairy_cost.errors.full_messages.join(", ") }, status: :unprocessable_entity
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
      render json: { message: "DairyCost deleted" }
    else
      render json: { error: "DairyCost not deleted" }
    end
  end

  #get the cost price for a specific dairy_cost record
  def cost_price
    dairy_cost = DairyCost.find(params[:id])
    if dairy_cost
      render json: { message: "DairyCost with id #{params[:id]} has #{dairy_cost.cost_price} as cost price" }
    else
      render json: { error: "DairyCost with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # Total Dairy Cost
  def total_dairy_cost
    total = {}
    DairyCost.all.each do |dairy_cost|
      if total[dairy_cost.item]
        total[dairy_cost.item] += dairy_cost.price
      else
        total[dairy_cost.item] = dairy_cost.price
      end
    end
    return total.values.sum
  end

  def total
    total = total_dairy_cost
    render json: { message: "Total Dairy Cost is #{total}" }
  end


  # def sort_costs_by_month
  #   start_date = Date.new(2023, 1, 1)
  #   end_date = Date.new(2023, 12, 31)

  #   sell_hash = {}

  #   (start_date..end_date).each do |date|
  #     month = date.strftime("%B")
  #     unless sell_hash.key?(month)
  #       start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
  #       end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

  #       sells = DairyCost.where(date: start_date_str..end_date_str)

  #       admin_totals = sells.group_by(&:admin_id).transform_values { |sells| sells.sum(&:price) }
  #       sell_records = sells.sort_by(&:price).reverse

  #       sell_hash[month] = {
  #         month: month,
  #         admin_totals: admin_totals,
  #         sell_records: sell_records,
  #       }
  #     end
  #   end

  #   sell_array = sell_hash.values

  #   render json: { message: "Dairy costs by Month", sell_array: sell_array }
  # end

  # def admin_totals
  #   sells = DairyCost.all
  #   overall_admin_totals = sells.group_by(&:admin_id).transform_values { |sells| sells.sum(&:price) }

  #   monthly_admin_totals = {}
  #   start_date = Date.new(2023, 1, 1)
  #   end_date = Date.new(2023, 12, 31)

  #   (start_date..end_date).each do |date|
  #     start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
  #     end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

  #     monthly_sells = sells.where(date: start_date_str..end_date_str)
  #     monthly_admin_totals[date.strftime("%B")] = monthly_sells.group_by(&:admin_id).transform_values { |sells| sells.sum(&:price) }
  #   end

  #   render json: { message: "Admin Totals", overall_admin_totals: overall_admin_totals, monthly_admin_totals: monthly_admin_totals }
  # end

  private

  def dairy_cost_params
    params.permit(:price, :item, :date, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
