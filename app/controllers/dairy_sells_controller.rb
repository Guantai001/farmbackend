class DairySellsController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :total, :sort_sells_by_month, :admin_totals]

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
      render json: { error: dairy_sell.errors.full_messages.join(", ") }, status: :unprocessable_entity
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
      render json: { message: "DairySell deleted" }
    else
      render json: { error: "DairySell not deleted" }
    end
  end

  #get the sold price for a specific dairy_sell record
  def sold_price
    dairy_sell = DairySell.find(params[:id])
    if dairy_sell
      render json: { message: "DairySell with id #{params[:id]} has #{dairy_sell.sold_price} as sold price" }
    else
      render json: { error: "DairySell with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # Total Dairy Sell
  def total_dairy_sell
    total = {}
    DairySell.all.each do |dairy_sell|
      if total[dairy_sell.item]
        total[dairy_sell.item] += dairy_sell.price
      else
        total[dairy_sell.item] = dairy_sell.price
      end
    end
    return total.values.sum
  end

  def total
    total = total_dairy_sell
    render json: { message: "Total Dairy Sell is #{total}" }
  end

  #   sort by month
  # def sort_sells_by_month
  #   start_date = Date.new(2023, 1, 1)
  #   end_date = Date.new(2023, 12, 31)

  #   sell_hash = {}

  #   (start_date..end_date).each do |date|
  #     month = date.strftime("%B")
  #     unless sell_hash.key?(month)
  #       start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
  #       end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

  #       sells = DairySell.where(date: start_date_str..end_date_str)

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

  #   render json: { message: "Dairy Sells by Month", sell_array: sell_array }
  # end

  # def admin_totals
  #   sells = DairySell.all
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

  def dairy_sell_params
    params.permit(:item, :price, :date, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
