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

ActiveRecord::Schema.define(:version => 20120718000104) do

  create_table "bids", :force => true do |t|
    t.integer  "item_id",                                                      :null => false
    t.decimal  "offer",      :precision => 10, :scale => 0, :default => 0
    t.string   "units",                                     :default => "USD"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.integer  "user_id"
  end

  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "elements", :force => true do |t|
    t.integer  "item_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "metadata"
  end

  create_table "items", :force => true do |t|
    t.integer  "quantity",    :default => 0
    t.string   "units",       :default => "kg"
    t.string   "title",       :default => "No title"
    t.text     "description"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "user_id"
  end

  add_index "items", ["user_id", "id"], :name => "index_items_on_user_id_and_id", :unique => true
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "company",                :default => "", :null => false
    t.string   "address",                                :null => false
    t.string   "city",                                   :null => false
    t.string   "zip",                    :default => "", :null => false
    t.string   "state",                  :default => "", :null => false
    t.string   "country",                :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
