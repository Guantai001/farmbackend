class MilkPricesController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :latest]

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
  def latest_admin_milk
    milks = Milk.all
    overall_admin_totals = milks.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }

    monthly_admin_totals = {}
    start_date = Date.new(2023, 1, 1)
    end_date = Date.new(2023, 12, 31)

    (start_date..end_date).each do |date|
      start_date_str = date.at_beginning_of_month.strftime("%Y-%m-%d")
      end_date_str = date.at_end_of_month.strftime("%Y-%m-%d")

      monthly_sells = milks.where(date: start_date_str..end_date_str)
      monthly_admin_totals[date.strftime("%B")] = monthly_sells.group_by(&:admin_id).transform_values { |milks| milks.sum(&:amount) }
    end

    render json: { message: "Milk records sorted by month and admin", overall_admin_totals: overall_admin_totals, monthly_admin_totals: monthly_admin_totals }
  end

  def latest
    admins = Admin.all
    result = []

    admins.each do |admin|
      monthly_totals = {}
      milk_price = admin.milk_prices.order(created_at: :desc).first

      (1..12).each do |month_number|
        month = Date.new(Date.today.year, month_number, 1).strftime("%B %Y")
        milk_records = admin.milks.where(date: Date.new(Date.today.year, month_number, 1)..Date.new(Date.today.year, month_number, -1))
        total_amount = milk_records.sum(:amount)
        total = milk_price ? milk_price.price * total_amount : nil
        total_amount = total_amount > 0 ? total_amount : nil
        monthly_totals[month] = { price: milk_price&.price, total_amount: total_amount, total: total }
      end
      result << { admin_id: admin.id, monthly_totals: monthly_totals }
    end
    render json: result
  end

  private

  def milk_price_params
    params.permit(:price, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end
