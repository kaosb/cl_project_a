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

ActiveRecord::Schema.define(version: 20160814055938) do

  create_table "cars", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "imagen"
    t.string   "link"
    t.string   "titulo"
    t.integer  "ano"
    t.integer  "precio"
    t.string   "vendedor"
    t.string   "publicado"
    t.integer  "visto"
    t.string   "marca"
    t.string   "modelo"
    t.string   "version"
    t.string   "tipo"
    t.string   "carroceria"
    t.string   "color"
    t.integer  "kilometraje"
    t.integer  "cilindrada"
    t.string   "transmision"
    t.string   "direccion"
    t.string   "aire"
    t.string   "radio"
    t.string   "alzavidrios"
    t.string   "espejos"
    t.string   "frenos"
    t.string   "airbags"
    t.string   "cierre"
    t.string   "catalitico"
    t.string   "combustible"
    t.string   "traccion"
    t.string   "llantas"
    t.integer  "puertas"
    t.string   "alarma"
    t.string   "techo"
    t.string   "patente"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "status",      default: true
  end

  create_table "sqlite_stat1", id: false, force: :cascade do |t|
    t. "tbl"
    t. "idx"
    t. "stat"
  end

end
