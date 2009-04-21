# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090401162409) do

  create_table "gather_sessions", :force => true do |t|
    t.date     "begin_date"
    t.date     "end_date"
    t.integer  "page_start"
    t.integer  "page_end"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owners", :force => true do |t|
    t.string   "owner_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "photo_id"
    t.string   "secret"
    t.integer  "server"
    t.integer  "farm"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_taken"
  end

end
