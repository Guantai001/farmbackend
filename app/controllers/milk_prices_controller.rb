class MilkPricesController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :latest, :profit_loss]

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
    milk_price = MilkPrice.new(milk_price_params)
    if milk_price.save
      render json: milk_price.as_json, status: :created
    else
      render json: { error: milk_price.errors.full_messages.join(", ") }, status: :unprocessable_entity
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
      render json: { message: "MilkPrice deleted" }
    else
      render json: { error: "MilkPrice not deleted" }
    end
  end

  #    import data from MilkController
  def some_milk_price_action
    milks_controller = MilksController.new
    milks_controller.admin_milk
    milks_controller.index
    milks_controller.create
  end

  #get the data of the admin_milk
  # def latest_admin_milk
  #   milks = Milk.all
  #   overall_admin_totals = milks.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }

  #   monthly_admin_totals = {}
  #   start_date = Date.new(2023, 1, 1)
  #   end_date = Date.new(2023, 12, 31)

  #   (start_date..end_date).each do |date|
  #     start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
  #     end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

  #     monthly_sells = milks.where(date: start_date_str..end_date_str)
  #     monthly_admin_totals[date.strftime("%B")] = monthly_sells.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }
  #   end

  #   render json: { message: "Milk records sorted by month and admin", overall_admin_totals: overall_admin_totals, monthly_admin_totals: monthly_admin_totals }
  # end

  # # def latest
  #   admins = Admin.all
  #   milks = Milk.all

  #   overall_admin_totals = milks.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }

  #   monthly_admin_totals = {}
  #   start_date = Date.new(2023, 1, 1)
  #   end_date = Date.new(2023, 12, 31)

  #   (start_date..end_date).each do |date|
  #     start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
  #     end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

  #     monthly_sells = milks.where(date: start_date_str..end_date_str)
  #     monthly_admin_totals[date.strftime("%B")] = monthly_sells.group_by(&:admin_id).transform_values do |milks|
  #       milks.sum do |milk|
  #         admin_price = milk.admin.milk_prices.order(created_at: :desc).first&.price.to_f
  #         milk.amount * admin_price
  #       end
  #     end
  #   end

  #   render json: { message: "Milk records sorted by month and admin", overall_admin_totals: overall_admin_totals, monthly_admin_totals: monthly_admin_totals }
  # end

  def profit_loss
    admins = Admin.all
    milks = Milk.all
    costs = DairyCost.all
    sells = DairySell.all
    monthly_admin_totals = {}
    monthly_total_sells = {}
    monthly_total_costs = {}
    end_date = Date.today
    start_date = end_date - 11.months
    (start_date..end_date).each do |date|
      month_str = date.strftime("%B")
      monthly_admin_totals[month_str] = {}
      monthly_total_sells[month_str] = 0
      monthly_total_costs[month_str] = 0
      admins.each do |admin|
        admin_id = admin.id
        monthly_milks = milks.where(admin_id: admin_id, date: date.at_beginning_of_month..date.at_end_of_month)
        monthly_milk_amount = monthly_milks.sum(&:amount)
        monthly_sells = sells.where(admin_id: admin_id, date: date.at_beginning_of_month..date.at_end_of_month)
        monthly_sells_total = monthly_sells.sum(&:price)
        monthly_total_sells[month_str] += monthly_sells_total
        monthly_costs = costs.where(admin_id: admin_id, date: date.at_beginning_of_month..date.at_end_of_month)
        monthly_costs_total = monthly_costs.sum(&:price)
        monthly_total_costs[month_str] += monthly_costs_total
        last_price_input = admin.milk_prices.order(created_at: :desc).first&.price.to_f
        milk_amount_price = monthly_milk_amount * last_price_input
        profit_loss_with_price = monthly_sells_total - monthly_costs_total + milk_amount_price
        monthly_admin_totals[month_str][admin_id] = {
          profit_loss: monthly_sells_total - monthly_costs_total == 0 ? nil : monthly_sells_total - monthly_costs_total,
          milk_amount: monthly_milk_amount == 0 ? nil : monthly_milk_amount,
          last_price_input: last_price_input == 0.0 ? nil : last_price_input,
          milk_amount_price: milk_amount_price == 0.0 ? nil : milk_amount_price,
          profit_loss_with_price: profit_loss_with_price == 0.0 ? nil : profit_loss_with_price,
          total_sells: monthly_sells_total == 0 ? nil : monthly_sells_total,
          total_costs: monthly_costs_total == 0 ? nil : monthly_costs_total,
        }
      end
    end
    render json: {
      monthly_admin_totals: monthly_admin_totals,
    }
  end
  

  private

  def milk_price_params
    params.permit(:price, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
