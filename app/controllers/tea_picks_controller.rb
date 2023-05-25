class TeaPicksController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :last_month, :last_one_month]

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

  def last_one_month
    # Get the first day of the current month
    current_month_start = Date.today.beginning_of_month

    # Get the first day of the previous month
    previous_month_start = (current_month_start - 1.month).beginning_of_month

    # Get the first day of the current month
    current_month_end = current_month_start.end_of_month

    # Retrieve the tea picks within the previous month
    tea_picks = TeaPick.where(date: previous_month_start..current_month_end)

    render json: tea_picks
  end

  def last_month
    admins = Admin.all
    farms = Tea.all
    teas = TeaPick.all
    monthly_admin_totals = {}
    monthly_farm_totals = {}
    monthly_total_picks = {}
    monthly_total_farm = {}

    end_date = Date.today
    start_date = end_date - 11.months
    (start_date..end_date).each do |date|
      month_str = date.strftime("%B")
      monthly_admin_totals[month_str] = {}
      monthly_farm_totals[month_str] = {}
      monthly_total_picks[month_str] = 0
      monthly_total_farm[month_str] = 0

      admins.each do |admin|
        admin_id = admin.id
        monthly_picks = teas.where(admin_id: admin_id, date: date.beginning_of_month..date.end_of_month)
        monthly_picks_amount = monthly_picks.sum(:kilo)

        monthly_admin_totals[month_str][admin_id] = monthly_picks_amount
        monthly_total_picks[month_str] += monthly_picks_amount
      end

      farms.each do |farm|
        farm_id = farm.id
        farm_admin_id = farm.admin_id
        monthly_picks = teas.where(tea_id: farm_id, date: date.beginning_of_month..date.end_of_month)
        monthly_picks_amount = monthly_picks.sum(:kilo)

        monthly_farm_totals[month_str][farm_id] ||= {}
        monthly_farm_totals[month_str][farm_id][:admin_id] = farm_admin_id
        monthly_farm_totals[month_str][farm_id][:kilo] = monthly_picks_amount
        monthly_total_farm[month_str] += monthly_picks_amount
      end
    end

    render json: { monthly_admin_totals: monthly_admin_totals, monthly_farm_totals: monthly_farm_totals, monthly_total_picks: monthly_total_picks, monthly_total_farm: monthly_total_farm }
  end

  private

  def tea_pick_params
    params.permit(:kilo, :price, :date, :tea_id, :admin_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end
end

# admins.each do |admin|

#   admin_id = admin.id
#   monthly_picks = teas.where(admin_id: admin_id, date: date.beginning_of_month..date.end_of_month)
#   monthly_picks_amount = monthly_picks.sum(&:kilo)
#   monthly_admin_totals[month_str][admin_id] = monthly_picks_amount
#   monthly_total_picks[month_str] += monthly_picks_amount
# end
# end
