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

ActiveRecord::Schema.define(:version => 20120814233833) do

  create_table "auxiliaries", :force => true do |t|
    t.integer  "bid_id",     :null => false
    t.integer  "s_id",       :null => false
    t.string   "s_type",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "auxiliaries", ["bid_id", "s_id", "s_type"], :name => "index_auxiliaries_on_bid_id_and_s_id_and_s_type", :unique => true
  add_index "auxiliaries", ["bid_id"], :name => "index_auxiliaries_on_bid_id"
  add_index "auxiliaries", ["s_id", "s_type"], :name => "index_auxiliaries_on_s_id_and_s_type"

  create_table "bids", :force => true do |t|
    t.integer  "item_id",                                                       :null => false
    t.decimal  "offer",       :precision => 10, :scale => 0, :default => 0
    t.string   "units",                                      :default => "USD"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.integer  "user_id"
    t.string   "paytype"
    t.integer  "location_id"
    t.decimal  "maw",         :precision => 10, :scale => 0
    t.string   "shipping"
    t.integer  "target_id"
  end

  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

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
    t.integer  "quantity",                                     :default => 0
    t.string   "units",                                        :default => "kg"
    t.string   "title",                                        :default => "No title"
    t.text     "description"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.integer  "user_id"
    t.string   "material"
    t.string   "category",                                     :default => "plastic",  :null => false
    t.integer  "location_id"
    t.string   "material_type"
    t.decimal  "maw",           :precision => 10, :scale => 0
    t.integer  "target_id"
  end

  add_index "items", ["target_id"], :name => "index_items_on_target_id"
  add_index "items", ["user_id", "id"], :name => "index_items_on_user_id_and_id", :unique => true
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "name"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "shipping",   :default => "EXWORKS", :null => false
    t.boolean  "official",   :default => false,     :null => false
  end

  add_index "locations", ["name"], :name => "index_locations_on_name", :unique => true

  create_table "ports", :force => true do |t|
    t.string   "city"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ports", ["city"], :name => "index_ports_on_city"
  add_index "ports", ["code"], :name => "index_ports_on_code", :unique => true

  create_table "services", :force => true do |t|
    t.string   "company",                                    :default => "Tracago", :null => false
    t.string   "title",                                                             :null => false
    t.string   "description",                                                       :null => false
    t.decimal  "price",       :precision => 10, :scale => 0, :default => 0,         :null => false
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.datetime "expiration"
  end

  add_index "services", ["company"], :name => "index_services_on_company"
  add_index "services", ["title"], :name => "index_services_on_title"

  create_table "ships", :force => true do |t|
    t.string   "company",                                                  :null => false
    t.integer  "start"
    t.integer  "finish"
    t.decimal  "price",      :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.datetime "expiration"
  end

  add_index "ships", ["company"], :name => "index_ships_on_company"
  add_index "ships", ["start", "finish"], :name => "index_ships_on_start_and_finish"

  create_table "statuses", :force => true do |t|
    t.string   "name",       :default => "incomplete", :null => false
    t.string   "effect"
    t.integer  "item_id",                              :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "statuses", ["item_id", "name"], :name => "index_statuses_on_item_id_and_name", :unique => true
  add_index "statuses", ["item_id"], :name => "index_statuses_on_item_id"
  add_index "statuses", ["name"], :name => "index_statuses_on_name"

  create_table "targets", :force => true do |t|
    t.integer  "t_id"
    t.string   "t_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "targets", ["t_id", "t_type"], :name => "index_targets_on_t_id_and_t_type"

  create_table "trucks", :force => true do |t|
    t.string   "company",                                                  :null => false
    t.integer  "start"
    t.integer  "finish"
    t.decimal  "price",      :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.datetime "expiration"
  end

  add_index "trucks", ["company"], :name => "index_trucks_on_company"
  add_index "trucks", ["start", "finish"], :name => "index_trucks_on_start_and_finish"

  create_table "users", :force => true do |t|
    t.string   "company",                :default => "",    :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.integer  "location_id"
    t.string   "phone",                  :default => "",    :null => false
    t.string   "extention"
  end

  add_index "users", ["company"], :name => "index_users_on_company"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "yards", :force => true do |t|
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
