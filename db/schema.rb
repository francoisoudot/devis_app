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

ActiveRecord::Schema.define(version: 20140922223806) do

  create_table "clients", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ln_fl"
    t.string   "address"
    t.string   "postal_code"
    t.string   "city"
    t.string   "phone"
    t.string   "company"
    t.string   "res1"
    t.string   "res2"
    t.string   "res3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.string   "title"
    t.text     "list"
    t.text     "comment"
    t.integer  "quote_id"
    t.integer  "status"
    t.decimal  "total"
    t.decimal  "tax_rate"
    t.decimal  "discount"
    t.decimal  "total_paid"
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "client_id"
    t.string   "res1"
    t.string   "res2"
    t.string   "res3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id"

  create_table "quotes", force: true do |t|
    t.string   "title"
    t.integer  "status"
    t.integer  "email_count"
    t.text     "list"
    t.text     "comment"
    t.decimal  "total"
    t.decimal  "tax_rate"
    t.decimal  "discount"
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "client_id"
    t.string   "res1"
    t.string   "res2"
    t.string   "res3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quotes", ["client_id"], name: "index_quotes_on_client_id"

  create_table "sub_invoices", force: true do |t|
    t.string   "title"
    t.text     "comment"
    t.integer  "status"
    t.integer  "echeance"
    t.decimal  "total"
    t.datetime "starttime"
    t.datetime "endtime"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_invoices", ["invoice_id"], name: "index_sub_invoices_on_invoice_id"

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
