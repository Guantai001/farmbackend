class CowsController < ApplicationController
    skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy]

    # rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # get all Admins
  def index
    cows = Cow.all
    # put image_url in the attributes
    render json: cows, methods: [:image, :image_url]
end

# get one Admin
def show
    cows = Cow.find_by(id: params[:id])
    if cows
      render json: cows, methods: [:image]
    else
      # If the id is not found 
      render json: { error: "Animal with id #{params[:id]} not found" }, status: :not_found
    end
  end

# create new Admin
def create
  cow = Cow.new(cow_params)
  if cow.save
    render json: cow, status: :created
  else
    render json: { error: cow.errors.full_messages }, status: :unprocessable_entity
  end
end

# update Admin
def update
 cows = Cow.find(params[:id])
 cows.update!(cow_params)
render json: cows, status: :accepted
end


# delete Admin
def destroy
    cows = Cow.find(params[:id])
    if cows.destroy
        render json: {message: "Animal deleted"}
    else
        render json: {error: "Animal not deleted"}
    end
end

private

   private
     def cow_params
      params.permit(:name, :breed, :health, :age, :admin_id, :image)
    end
  
   
     def render_unprocessable_entity_response(exception)
       render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
     end
end
