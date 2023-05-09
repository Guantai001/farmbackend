class CreateCows < ActiveRecord::Migration[7.0]
  def change
    create_table :cows do |t|
      t.string :name
      t.integer :age
      t.string :breed
      t.string :health

      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
