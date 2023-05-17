class CreateMilkPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :milk_prices do |t|
      t.integer :price

      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
