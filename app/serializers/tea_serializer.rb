class TeaSerializer < ActiveModel::Serializer
  attributes :id, :name, :locaation, :size, :admin_id, :image_url
end
