class TeaSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :size, :admin_id, :image_url
end
