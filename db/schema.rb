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

ActiveRecord::Schema[8.1].define(version: 2026_02_07_222308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "genre_id"], name: "index_game_genres_on_game_id_and_genre_id", unique: true
    t.index ["game_id"], name: "index_game_genres_on_game_id"
    t.index ["genre_id"], name: "index_game_genres_on_genre_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "cover_image_url"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "developers", default: [], array: true
    t.bigint "igdb_id"
    t.string "platforms", default: [], array: true
    t.date "release_date"
    t.string "slug", null: false
    t.string "source", default: "igdb", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.decimal "user_rating", precision: 4, scale: 2
    t.index ["igdb_id"], name: "index_games_on_igdb_id"
    t.index ["platforms"], name: "index_games_on_platforms", using: :gin
    t.index ["slug"], name: "index_games_on_slug", unique: true
    t.index ["source", "igdb_id"], name: "index_games_on_source_and_igdb_id", unique: true
  end

  create_table "genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_genres_on_slug", unique: true
  end

  add_foreign_key "game_genres", "games"
  add_foreign_key "game_genres", "genres"
end
