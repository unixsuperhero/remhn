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

ActiveRecord::Schema[7.0].define(version: 2024_01_25_022203) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "elements", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipables", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.integer "group"
    t.integer "subgroup"
    t.integer "power"
    t.integer "affinity"
    t.integer "element_power"
    t.integer "grade"
    t.bigint "element_id"
    t.bigint "monster_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_equipables_on_element_id"
    t.index ["monster_id"], name: "index_equipables_on_monster_id"
  end

  create_table "forge_items", force: :cascade do |t|
    t.bigint "equipable_id", null: false
    t.bigint "level_id", null: false
    t.bigint "item_id", null: false
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipable_id"], name: "index_forge_items_on_equipable_id"
    t.index ["item_id"], name: "index_forge_items_on_item_id"
    t.index ["level_id"], name: "index_forge_items_on_level_id"
  end

  create_table "item_sources", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.integer "stars"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_sources_on_item_id"
    t.index ["source_type", "source_id"], name: "index_item_sources_on_source"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "item_type"
    t.integer "rarity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade do |t|
    t.bigint "equipable_id", null: false
    t.string "grade_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipable_id"], name: "index_levels_on_equipable_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "terrain_name"
    t.bigint "terrain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["terrain_id"], name: "index_locations_on_terrain_id"
  end

  create_table "monster_elements", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_monster_elements_on_element_id"
    t.index ["monster_id"], name: "index_monster_elements_on_monster_id"
  end

  create_table "monster_items", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "item_id", null: false
    t.integer "stars"
    t.string "monster_code"
    t.string "item_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_monster_items_on_item_id"
    t.index ["monster_id"], name: "index_monster_items_on_monster_id"
  end

  create_table "monster_terrains", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "terrain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monster_id"], name: "index_monster_terrains_on_monster_id"
    t.index ["terrain_id"], name: "index_monster_terrains_on_terrain_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.integer "size"
    t.integer "poison"
    t.integer "paralysis"
    t.integer "stun"
    t.integer "sleep"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skill_levels", force: :cascade do |t|
    t.bigint "skill_id", null: false
    t.bigint "level_id", null: false
    t.bigint "equipable_id", null: false
    t.integer "power"
    t.string "grade_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipable_id"], name: "index_skill_levels_on_equipable_id"
    t.index ["level_id"], name: "index_skill_levels_on_level_id"
    t.index ["skill_id"], name: "index_skill_levels_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stars", force: :cascade do |t|
    t.integer "stars"
    t.bigint "monster_id", null: false
    t.integer "hp"
    t.integer "raid_hp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monster_id"], name: "index_stars_on_monster_id"
  end

  create_table "terrains", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weaknesses", force: :cascade do |t|
    t.bigint "monster_id", null: false
    t.bigint "element_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_weaknesses_on_element_id"
    t.index ["monster_id"], name: "index_weaknesses_on_monster_id"
  end

  add_foreign_key "item_sources", "items"
end
