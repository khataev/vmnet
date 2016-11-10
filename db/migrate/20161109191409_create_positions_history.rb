class CreatePositionsHistory < ActiveRecord::Migration
  def change
    create_table :positions_histories do |t|
      t.date :date
      t.text :positions
    end
    add_index :positions_histories, :date
  end
end
