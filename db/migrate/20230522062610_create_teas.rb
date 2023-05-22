class CreateTeas < ActiveRecord::Migration[7.0]
  def change
    create_table :teas do |t|
      t.string :name
      t.string :locaation
      t.integer :size

      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
