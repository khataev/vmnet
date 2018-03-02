class CreatePositionsHistory < ActiveRecord::Migration[4.2]
  def change
    create_table :positions_histories do |t|
      t.date :date
      t.text :positions
    end
    add_index :positions_histories, :date
  end
end
