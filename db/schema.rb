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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140218092829) do

  create_table "cargo_wiki_articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "author_id"
    t.boolean  "published",  :default => true
  end

  create_table "cargo_wiki_users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "auth_token"
    t.string   "role"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["commentable_type", "commentable_id"], :name => "index_comments_on_commentable_type_and_commentable_id"

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.string   "nature"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "flags", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "likeable_type"
    t.integer  "likeable_id"
  end

  create_table "mindlogs", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
    t.text     "status"
    t.integer  "reports_counter"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "counter"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "text"
    t.string   "tag"
    t.string   "scope"
  end

  create_table "offers", :force => true do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "read_marks", :force => true do |t|
    t.integer  "readable_id"
    t.integer  "user_id",                     :null => false
    t.string   "readable_type", :limit => 20, :null => false
    t.datetime "timestamp"
  end

  add_index "read_marks", ["user_id", "readable_type", "readable_id"], :name => "index_read_marks_on_user_id_and_readable_type_and_readable_id"

  create_table "reports", :force => true do |t|
    t.integer  "flag_id"
    t.integer  "user_id"
    t.string   "reportable_type"
    t.integer  "reportable_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "responses", :force => true do |t|
    t.text     "body"
    t.integer  "mindlog_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
    t.integer  "rating"
    t.integer  "last_commenter"
    t.string   "nature"
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "searchjoy_searches", :force => true do |t|
    t.string   "search_type"
    t.string   "query"
    t.string   "normalized_query"
    t.integer  "results_count"
    t.datetime "created_at"
    t.integer  "convertable_id"
    t.string   "convertable_type"
    t.datetime "converted_at"
  end

  add_index "searchjoy_searches", ["convertable_id", "convertable_type"], :name => "index_searchjoy_searches_on_convertable_id_and_convertable_type"
  add_index "searchjoy_searches", ["created_at"], :name => "index_searchjoy_searches_on_created_at"
  add_index "searchjoy_searches", ["search_type", "created_at"], :name => "index_searchjoy_searches_on_search_type_and_created_at"
  add_index "searchjoy_searches", ["search_type", "normalized_query", "created_at"], :name => "index_searchjoy_searches_on_search_type_and_normalized_query_an"

  create_table "stasus", :force => true do |t|
    t.string   "title"
    t.string   "colour"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "subscribable_type"
    t.integer  "subscribable_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "counter"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                               :null => false
    t.string   "encrypted_password",                                  :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0, :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "username"
    t.string   "gender",                 :limit => 8
    t.date     "dob"
    t.text     "body"
    t.string   "country",                :limit => 64
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "commit_message"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "votes", :force => true do |t|
    t.integer  "response_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
  end

  create_table "wiki_pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "wiki_pages", ["slug"], :name => "index_wiki_pages_on_slug", :unique => true

end
