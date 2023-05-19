class AdminsController < ApplicationController
  skip_before_action :authorized, only: [:index, :create, :show, :update, :destroy]

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # get all Admins
  def index
    admin = Admin.all
    render json: admin
  end

  # get one Admin
  def show
    admin = Admin.find_by(id: params[:id])
    if admin
      render json: admin
    else
      # If the id is not found
      render json: { error: "Admin with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # create new Admin
  def create
    admin = Admin.new(admin_params)
    if admin.save
      render json: admin.as_json(except: [:image]), status: :created
    else
      render json: { error: admin.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  # update Admin
  def update
    admin = Admin.find(params[:id])
    admin.update(admin_params)
    render json: admin, status: :accepted
  end

  # delete Admin
  def destroy
    admin = Admin.find(params[:id])
    if admin.destroy
      render json: { message: "Admin deleted" }
    else
      render json: { error: "Admin not deleted" }
    end
  end

  def latest
    admin = Admin.last
    render json: AdminSerializer.new(admin).serializable_hash[:data][:attributes]
  end

  private

  def admin_params
    params.permit(:name, :email, :phone, :password, :image)
  end

  def render_unprocessable_entity_response(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end
