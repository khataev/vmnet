class CreateRatesHistories < ActiveRecord::Migration
  def change
    create_table :rates_histories do |t|
      t.date :date
      t.xml :rates

      t.timestamps null: false
    end
    add_index :rates_histories, :date
  end
end
