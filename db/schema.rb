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

ActiveRecord::Schema[8.1].define(version: 2026_09_11_084646) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "option_id", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["option_id", "value"], name: "index_option_values_on_option_id_and_value", unique: true
    t.index ["option_id"], name: "index_option_values_on_option_id"
  end

  create_table "options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_options_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.decimal "base_price", null: false
    t.string "brand"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image_url"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "variant_option_values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "option_value_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.index ["option_value_id"], name: "index_variant_option_values_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_variant_option_values_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_variant_option_values_on_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "price", null: false
    t.bigint "product_id", null: false
    t.string "sku", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["sku"], name: "index_variants_on_sku", unique: true
  end

  add_foreign_key "option_values", "options"
  add_foreign_key "options", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "variant_option_values", "option_values"
  add_foreign_key "variant_option_values", "variants"
  add_foreign_key "variants", "products"
end
