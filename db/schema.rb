# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 5) do

  create_table "card_instances", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
    t.integer "count"
    t.string "timestamp"
    t.index ["card_id"], name: "index_card_instances_on_card_id"
    t.index ["user_id"], name: "index_card_instances_on_user_id"
  end

  create_table "card_sets", force: :cascade do |t|
    t.string "name"
    t.datetime "release_date"
    t.string "timestamp"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.string "mana_cost"
    t.string "cmc"
    t.string "rules_text"
    t.string "card_type"
    t.integer "card_set_id"
    t.string "timestamp"
    t.index ["card_set_id"], name: "index_cards_on_card_set_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.string "timestamp"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email_address"
  end

end
