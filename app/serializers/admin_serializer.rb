class AdminSerializer < ActiveModel::Serializer
  # include JSONAPI::Serializer
  attributes :id, :name, :email, :password, :phone, :image, :image_url 
end
