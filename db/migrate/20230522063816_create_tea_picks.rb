class CreateTeaPicks < ActiveRecord::Migration[7.0]
  def change
    create_table :tea_picks do |t|
      t.integer :kilo
      t.integer :price
      t.string :date

      t.references :tea, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
