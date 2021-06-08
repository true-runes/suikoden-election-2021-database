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

ActiveRecord::Schema.define(version: 2021_06_08_042625) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyze_syntaxes", force: :cascade do |t|
    t.string "language"
    t.text "sentences", array: true
    t.text "tokens", array: true
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_analyze_syntaxes_on_tweet_id"
  end

  create_table "assets", force: :cascade do |t|
    t.bigint "id_number"
    t.string "url"
    t.string "asset_type"
    t.boolean "is_public"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_assets_on_tweet_id"
  end

  create_table "chara_name_and_nicknames", force: :cascade do |t|
    t.bigint "character_name_id"
    t.bigint "character_nickname_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_name_id"], name: "index_chara_name_and_nicknames_on_character_name_id"
    t.index ["character_nickname_id"], name: "index_chara_name_and_nicknames_on_character_nickname_id"
  end

  create_table "chara_name_and_products", force: :cascade do |t|
    t.bigint "character_name_id"
    t.bigint "suikoden_product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_name_id"], name: "index_chara_name_and_products_on_character_name_id"
    t.index ["suikoden_product_id"], name: "index_chara_name_and_products_on_suikoden_product_id"
  end

  create_table "character_names", force: :cascade do |t|
    t.string "gensosenkyo"
    t.string "english"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "character_nicknames", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "direct_messages", force: :cascade do |t|
    t.bigint "id_number"
    t.datetime "messaged_at"
    t.string "text"
    t.bigint "sender_id_number"
    t.bigint "recipient_id_number"
    t.boolean "is_visible"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "api_response"
    t.index ["id_number"], name: "index_direct_messages_on_id_number", unique: true
    t.index ["user_id"], name: "index_direct_messages_on_user_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "text"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id", "text"], name: "index_hashtags_on_tweet_id_and_text", unique: true
    t.index ["tweet_id"], name: "index_hashtags_on_tweet_id"
  end

  create_table "in_tweet_urls", force: :cascade do |t|
    t.string "text"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id", "text"], name: "index_in_tweet_urls_on_tweet_id_and_text", unique: true
    t.index ["tweet_id"], name: "index_in_tweet_urls_on_tweet_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "user_id_number"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id", "user_id_number"], name: "index_mentions_on_tweet_id_and_user_id_number", unique: true
    t.index ["tweet_id"], name: "index_mentions_on_tweet_id"
  end

  create_table "suikoden_products", force: :cascade do |t|
    t.string "name"
    t.string "english_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.bigint "id_number", null: false
    t.string "full_text"
    t.string "source"
    t.bigint "in_reply_to_tweet_id_number"
    t.bigint "in_reply_to_user_id_number"
    t.boolean "is_retweet"
    t.string "language"
    t.boolean "is_public"
    t.datetime "tweeted_at"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_number"], name: "index_tweets_on_id_number", unique: true
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "id_number", null: false
    t.string "name", null: false
    t.string "screen_name", null: false
    t.string "profile_image_url_https"
    t.boolean "is_protected"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "born_at"
    t.index ["id_number"], name: "index_users_on_id_number", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["screen_name"], name: "index_users_on_screen_name"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "chara_name_and_nicknames", "character_names"
  add_foreign_key "chara_name_and_nicknames", "character_nicknames"
  add_foreign_key "chara_name_and_products", "character_names"
  add_foreign_key "chara_name_and_products", "suikoden_products"
end
