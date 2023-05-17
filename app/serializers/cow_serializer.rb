class CowSerializer < ActiveModel::Serializer
  # include JSONAPI::Serializer
  attributes :id, :name, :age, :breed, :health, :admin_id, :image_url
  
end
