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

ActiveRecord::Schema.define(version: 20160311150938) do

  create_table "books", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "author",      limit: 255
    t.string   "publication", limit: 255
    t.string   "tags",        limit: 255
    t.string   "isbn",        limit: 255
    t.string   "url",         limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "books", ["author"], name: "index_books_on_author", using: :btree
  add_index "books", ["isbn"], name: "index_books_on_isbn", using: :btree
  add_index "books", ["title"], name: "index_books_on_title", using: :btree

  create_table "friends", force: :cascade do |t|
    t.integer  "user_id",        limit: 4,   null: false
    t.string   "signup_id",      limit: 255, null: false
    t.integer  "friend_user_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "friends", ["user_id"], name: "index_friends_on_user_id", using: :btree

  create_table "notify_users", force: :cascade do |t|
    t.string   "email_id",   limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_books", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                                        null: false
    t.integer  "book_id",    limit: 4
    t.integer  "status",     limit: 4,                            default: 0
    t.string   "url",        limit: 255,                                      null: false
    t.decimal  "lat",                    precision: 10, scale: 6,             null: false
    t.decimal  "long",                   precision: 10, scale: 6,             null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email_id",      limit: 255,             null: false
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.integer  "status",        limit: 4,   default: 0
    t.integer  "signup_medium", limit: 4,   default: 0
    t.string   "signup_id",     limit: 255
    t.string   "access_token",  limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

end
