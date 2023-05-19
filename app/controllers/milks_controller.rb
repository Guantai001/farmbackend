class MilksController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :milk_kgs, :total_milk, 
    :total, :total_animal, :sort_by_month, :admin_milk]

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # get all Milks
  def index
    milk = Milk.all
    render json: milk, include: [:cow]
  end

  # get one Milk
  def show
    milk = Milk.find_by(id: params[:id])
    if milk
      render json: milk, include: [:cow]
    else
      # If the id is not found
      render json: { error: "Milk with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # create new Milk

  def create
    if !Milk.find_by(date: params[:date], cow_id: params[:cow_id])
      milk = Milk.new(milk_params)
      if milk.save
        render json: { message: "Milk Added Successfully" }
      else
        render json: milk, status: :unprocessable_entity
      end
    else
      render json: { error: "Milk already exists for this animal on this date" }
    end
  end

  # update Milk
  def update
    milk = Milk.find(params[:id])
    milk.update!(milk_params)
    render json: milk, status: :accepted
  end

  # delete Milk
  def destroy
    milk = Milk.find(params[:id])
    if milk.destroy
      render json: { message: "Milk deleted" }
    else
      render json: { error: "Milk not deleted" }
    end
  end

  # get milk_kgs for a specific milk record
  def milk_kgs
    milk = Milk.find(params[:id])
    if milk
      render json: { message: "Milk with id #{params[:id]} has #{milk.amount} kgs of milk" }
    else
      render json: { error: "Milk with id #{params[:id]} not found" }, status: :not_found
    end
  end

  #  Total milk from all
  def total_milk_kgs
    totals = {}
    Milk.all.each do |milk|
      animal_id = milk.cow_id
      if totals[animal_id]
        totals[animal_id] += milk.amount
      else
        totals[animal_id] = milk.amount
      end
    end
    return totals.values.sum
  end

  def total
    totals = total_milk_kgs
    render json: { message: "Total milk kgs for all animals: #{totals}" }
  end

  # TOTAL MILK FOR EACH ANIMAL ID
  def total_milk_kgs_animal
    totals = {}
    Milk.all.each do |milk|
      animal_id = milk.cow_id
      if totals[animal_id]
        totals[animal_id] += milk.amount
      else
        totals[animal_id] = milk.amount
      end
    end
    return totals
  end

  def total_animal
    # find the animal_id
    animal_id = params[:id]
    # get the total milk kgs for a specific animal_id
    totals = total_milk_kgs_animal
    # find the total milk kgs for a specific animal_id
    total = totals[animal_id.to_i]
    # render the total milk kgs for a specific animal_id
    render json: { message: "Total milk kgs for animal with id #{animal_id}: #{total}" }
  end

  def sort_by_month
    milk = Milk.all
    milk_by_month = milk.group_by { |m| [Date.parse(m.date).strftime("%B"), m.admin_id] }.transform_values do |milk_records|
      {
        total_amount: milk_records.sum(&:amount),
        milk_records: milk_records.sort_by(&:amount).reverse,
      }
    end
    months = Date::MONTHNAMES[1..12]
    milk_array = []
    months.each do |month|
      month_data = milk_by_month.select { |m| m[0][0] == month }
      admin_data = {}
      month_data.each do |m|
        admin_id = m[0][1]
        admin_data[admin_id] = {
          total_amount: m[1][:total_amount],
          milk_records: m[1][:milk_records],
        }
      end
      milk_array << { month: month, admin_data: admin_data }
    end
    render json: { message: "Milk records sorted by month and admin", milk: milk_array }
  end

  def admin_milk
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

  private

  def milk_params
    params.permit(:date, :amount, :cow_id, :admin_id)
  end

  def render_unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
