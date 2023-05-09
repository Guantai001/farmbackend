class CowSerializer 
  include JSONAPI::Serializer
  attributes :id, :name, :age, :breed, :health, :admin_id, :image,:image_url

end
