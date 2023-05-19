class AdminSerializer < ActiveModel::Serializer
  # include JSONAPI::Serializer
  attributes :id, :name, :email, :password, :phone, :image_url
  # has_many :cows
  has_many :dairy_sells
  has_many :dairy_costs
  has_many :milk_prices
  has_many :milks
end
