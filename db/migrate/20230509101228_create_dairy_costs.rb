class CreateDairyCosts < ActiveRecord::Migration[7.0]
  def change
    create_table :dairy_costs do |t|
      t.string :date
      t.integer :price
      t.string :item

      t.timestamps
    end
  end
end
