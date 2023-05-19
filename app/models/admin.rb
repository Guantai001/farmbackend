class Admin < ApplicationRecord
  has_secure_password
  has_one_attached :image
  has_many :milk_prices
  has_many :dairy_costs
  has_many :dairy_sells
  has_many :milks

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  #  during update validation
  validates :name, presence: false, on: :update
  validates :email, presence: false, on: :update
  validates :phone, presence: false, on: :update
  validates :password, presence: false, on: :update
  validates :image, presence: false, on: :update
end
