class CreateMilks < ActiveRecord::Migration[7.0]
  def change
    create_table :milks do |t|
      t.string :date
      t.integer :amount

      t.references :cow, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: true
      t.timestamps
    end
  end
end
