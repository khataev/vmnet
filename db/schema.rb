# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161126172232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "positions_histories", id: :serial, force: :cascade do |t|
    t.date "date"
    t.text "positions"
    t.index ["date"], name: "index_positions_histories_on_date"
  end

  create_table "rates_histories", id: :serial, force: :cascade do |t|
    t.date "date"
    t.xml "rates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_rates_histories_on_date"
  end

  create_table "spot_rates_histories", id: :serial, force: :cascade do |t|
    t.date "date"
    t.xml "rates"
    t.index ["date"], name: "index_spot_rates_histories_on_date"
  end

end
