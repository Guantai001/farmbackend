class MilksController < ApplicationController

    skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy, :milk_kgs, :total_milk, :total, :total_animal, :sort_by_month ]
    
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
            render json: {message: "Milk deleted"}
        else
            render json: {error: "Milk not deleted"}
        end
    end

    # get milk_kgs for a specific milk record
    def milk_kgs
        milk = Milk.find(params[:id])
        if milk
            render json: { message: "Milk with id #{params[:id]} has #{milk.amount} kgs of milk" }
        else
            render json: {error: "Milk with id #{params[:id]} not found"}, status: :not_found
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

    # sort milk by month
    def sort_by_month
        # set a sample date range of May 2023
        start_date_str = "2023-06-01"
        end_date_str = "2023-06-31"
        
        # retrieve all the milk records within the specified date range
        milk = Milk.where(date: start_date_str..end_date_str)
      
        # group the milk records by month and calculate the total amount of milk for each month
        milk_by_month = milk.group_by { |m| Date.parse(m.date).strftime("%B") }.transform_values do |milk_records|
          { 
            total_amount: milk_records.sum(&:amount),
            milk_records: milk_records.sort_by(&:amount).reverse
          }
        end
      
        # sort the hash by month name in ascending order
        sorted_milk = milk_by_month.sort_by { |month, milk| Date.parse("2000-#{Date::MONTHNAMES.index(month)}-01") }
      
        # format the sorted milk records as an array of hashes
        milk_array = sorted_milk.map do |month, milk|
          { month: month, total_amount: milk[:total_amount], milk_records: milk[:milk_records] } 
        end
      
        # render the sorted milk records as JSON
        render json: { message: "Milk records sorted by month", milk: milk_array }
      end
      
      
      
      
      
      

    # sort milk by year
    def sort_by_year
        # get all the milk records
        milk = Milk.all
        # get the year from the date
        year = params[:year]
        # filter the milk records by year
        filtered_milk = milk.select do |milk|
            milk.date.strftime("%Y") == year
        end
        # render the filtered milk records
        render json: { message: "Milk records for #{year}", milk: filtered_milk }
    end




    private

    def milk_params
        params.permit(:date, :amount, :cow_id)
    end

    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

end
