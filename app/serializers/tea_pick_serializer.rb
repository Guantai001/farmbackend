class TeaPickSerializer < ActiveModel::Serializer
  attributes :id, :kilo, :price, :date, :tea_id, :admin_id
  belongs_to :tea
end
