class MilkSerializer < ActiveModel::Serializer
  attributes :id, :amount, :cow_id, :date , :admin_id
  belongs_to :cow
end
