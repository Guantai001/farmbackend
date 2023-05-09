class CreateDairySells < ActiveRecord::Migration[7.0]
  def change
    create_table :dairy_sells do |t|
      t.string :date
      t.integer :price 
      t.string :item

      t.timestamps
    end
  end
end
