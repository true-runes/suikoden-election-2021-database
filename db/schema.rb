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

ActiveRecord::Schema.define(version: 2021_05_30_054844) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.bigint "id_number"
    t.string "url"
    t.string "asset_type"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_id"], name: "index_assets_on_tweet_id"
  end

  create_table "direct_messages", force: :cascade do |t|
    t.bigint "id_number"
    t.datetime "sent_at"
    t.string "text"
    t.bigint "sender_id_number"
    t.bigint "recipient_id_number"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_number"], name: "index_direct_messages_on_id_number", unique: true
    t.index ["user_id"], name: "index_direct_messages_on_user_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.string "text"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["text"], name: "index_hashtags_on_text", unique: true
    t.index ["tweet_id"], name: "index_hashtags_on_tweet_id"
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

  create_table "urls", force: :cascade do |t|
    t.string "text"
    t.bigint "tweet_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["text"], name: "index_urls_on_text", unique: true
    t.index ["tweet_id"], name: "index_urls_on_tweet_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "id_number", null: false
    t.string "name", null: false
    t.string "screen_name", null: false
    t.string "profile_image_url_https", default: "NOTHING", null: false
    t.boolean "is_protected"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_number"], name: "index_users_on_id_number", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["screen_name"], name: "index_users_on_screen_name"
  end

end
