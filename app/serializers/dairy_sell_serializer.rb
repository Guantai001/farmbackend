class DairySellSerializer < ActiveModel::Serializer
  attributes :id, :price , :item, :date, :admin_id
end
