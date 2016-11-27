class CreateSpotRatesHistory < ActiveRecord::Migration
  def change
    create_table :spot_rates_histories do |t|
      t.date :date
      t.xml :rates
    end
    add_index :spot_rates_histories, :date
  end
end
