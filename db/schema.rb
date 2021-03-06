# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160108125802) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "SQLITEADMIN_QUERIES", primary_key: "ID", force: true do |t|
    t.string "NAME", limit: 100
    t.text   "SQL"
  end

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "mailed",         default: false
    t.boolean  "read",           default: false
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["read", "mailed"], name: "index_activities_on_read_and_mailed", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "channel_items", force: true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "channel_id"
    t.string   "status",       default: "pending"
    t.integer  "submitter_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "channel_items", ["channel_id"], name: "index_channel_items_on_channel_id", using: :btree
  add_index "channel_items", ["item_type", "item_id"], name: "index_channel_items_on_item_type_and_item_id", using: :btree

  create_table "channels", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "comics", force: true do |t|
    t.string   "title"
    t.integer  "mindlog_id"
    t.integer  "user_id"
    t.integer  "likes_count",        default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "comic_file_name"
    t.string   "comic_content_type"
    t.integer  "comic_file_size"
    t.datetime "comic_updated_at"
    t.string   "status",             default: "unapproved"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree

  create_table "featured_mindlogs", force: true do |t|
    t.integer  "mindlog_id"
    t.integer  "moderator_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "nature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flags", force: true do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "likeable_type"
    t.integer  "likeable_id"
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "read"
    t.boolean  "mailed"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "pairing"
  end

  add_index "messages", ["pairing"], name: "index_messages_on_pairing", using: :btree
  add_index "messages", ["read", "mailed"], name: "index_messages_on_read_and_mailed", using: :btree
  add_index "messages", ["sender_id", "recipient_id"], name: "index_messages_on_sender_id_and_recipient_id", using: :btree

  create_table "mindlog_ratings", force: true do |t|
    t.integer  "mindlog_id"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mindlogs", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.text     "status"
    t.string   "workflow_state"
    t.integer  "rating_percent",  default: 0
    t.integer  "responses_count"
  end

  create_table "read_marks", force: true do |t|
    t.integer  "readable_id"
    t.integer  "reader_id",     null: false
    t.string   "readable_type", null: false
    t.datetime "timestamp"
    t.string   "reader_type"
  end

  add_index "read_marks", ["reader_id", "reader_type", "readable_type", "readable_id"], name: "read_marks_reader_readable_index", using: :btree

  create_table "reports", force: true do |t|
    t.integer  "flag_id"
    t.integer  "user_id"
    t.string   "reportable_type"
    t.integer  "reportable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "responses", force: true do |t|
    t.text     "body"
    t.integer  "mindlog_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.integer  "rating"
    t.integer  "last_commenter"
    t.string   "nature"
  end

  create_table "roles", force: true do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.string   "subscribable_type"
    t.integer  "subscribable_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "counter"
  end

  create_table "synapsedefs", force: true do |t|
    t.string   "synapse"
    t.string   "class"
    t.text     "def"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "updates", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                                           null: false
    t.string   "encrypted_password",                              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username"
    t.string   "gender",                 limit: 8
    t.date     "dob"
    t.text     "body"
    t.string   "country",                limit: 64
    t.string   "unconfirmed_email"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "options"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.float    "points",                            default: 0.0
    t.datetime "last_active_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "response_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  create_table "wiki_pages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  add_index "wiki_pages", ["slug"], name: "index_wiki_pages_on_slug", unique: true, using: :btree

end
