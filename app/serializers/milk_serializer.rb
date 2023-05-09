class MilkSerializer < ActiveModel::Serializer
  attributes :id, :amount, :cow_id, :date 
  belongs_to :cow
end
