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

ActiveRecord::Schema.define(version: 20160913150512) do

  create_table "car_history_tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "car_id",                 null: false
    t.string   "slug",       limit: 256
    t.string   "before",     limit: 256
    t.string   "after",      limit: 256
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "status"
  end

  create_table "cars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.integer  "site_id"
    t.string   "imagen",      limit: 256
    t.string   "link",        limit: 256
    t.string   "titulo",      limit: 256
    t.integer  "ano"
    t.integer  "precio"
    t.string   "vendedor",    limit: 256
    t.string   "publicado",   limit: 256
    t.integer  "visto"
    t.string   "marca",       limit: 256
    t.string   "modelo",      limit: 256
    t.string   "version",     limit: 256
    t.string   "tipo",        limit: 256
    t.string   "carroceria",  limit: 256
    t.string   "color",       limit: 256
    t.integer  "kilometraje"
    t.integer  "cilindrada"
    t.string   "transmision", limit: 256
    t.string   "direccion",   limit: 256
    t.string   "aire",        limit: 256
    t.string   "radio",       limit: 256
    t.string   "alzavidrios", limit: 256
    t.string   "espejos",     limit: 256
    t.string   "frenos",      limit: 256
    t.string   "airbags",     limit: 256
    t.string   "cierre",      limit: 256
    t.string   "catalitico",  limit: 256
    t.string   "combustible", limit: 256
    t.string   "traccion",    limit: 256
    t.string   "llantas",     limit: 256
    t.integer  "puertas"
    t.string   "alarma",      limit: 256
    t.string   "techo",       limit: 256
    t.string   "patente",     limit: 256
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "status"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
