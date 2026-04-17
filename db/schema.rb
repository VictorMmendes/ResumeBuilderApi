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

ActiveRecord::Schema[8.1].define(version: 2026_04_11_000009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "certifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", null: false
    t.string "name", null: false
    t.bigint "resume_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id", "display_order"], name: "index_certifications_on_resume_id_and_display_order", unique: true
    t.index ["resume_id"], name: "index_certifications_on_resume_id"
  end

  create_table "educations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "current"
    t.string "degree_name"
    t.integer "display_order", null: false
    t.date "end_date"
    t.string "field_of_study"
    t.string "institution"
    t.bigint "resume_id", null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["resume_id", "display_order"], name: "index_educations_on_resume_id_and_display_order", unique: true
    t.index ["resume_id"], name: "index_educations_on_resume_id"
  end

  create_table "experience_groups", force: :cascade do |t|
    t.string "company_name", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", null: false
    t.string "location"
    t.bigint "resume_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id", "display_order"], name: "index_experience_groups_on_resume_id_and_display_order", unique: true
    t.index ["resume_id"], name: "index_experience_groups_on_resume_id"
  end

  create_table "experience_position_bullets", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", null: false
    t.bigint "experience_position_id", null: false
    t.datetime "updated_at", null: false
    t.index ["experience_position_id", "display_order"], name: "idx_on_experience_position_id_display_order_0db9d92c7e", unique: true
    t.index ["experience_position_id"], name: "index_experience_position_bullets_on_experience_position_id"
  end

  create_table "experience_positions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "current", default: false, null: false
    t.integer "display_order", null: false
    t.date "end_date"
    t.bigint "experience_group_id", null: false
    t.date "start_date", null: false
    t.text "summary"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["experience_group_id", "display_order"], name: "idx_on_experience_group_id_display_order_21c313e501", unique: true
    t.index ["experience_group_id"], name: "index_experience_positions_on_experience_group_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "github_url"
    t.string "headline"
    t.string "linkedin_url"
    t.string "phone"
    t.string "portfolio_label"
    t.string "region"
    t.string "street_address"
    t.text "summary"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_resumes_on_user_id"
  end

  create_table "top_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "display_order", null: false
    t.string "name", null: false
    t.bigint "resume_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id", "display_order"], name: "index_top_skills_on_resume_id_and_display_order", unique: true
    t.index ["resume_id"], name: "index_top_skills_on_resume_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "certifications", "resumes"
  add_foreign_key "educations", "resumes"
  add_foreign_key "experience_groups", "resumes"
  add_foreign_key "experience_position_bullets", "experience_positions"
  add_foreign_key "experience_positions", "experience_groups"
  add_foreign_key "resumes", "users"
  add_foreign_key "top_skills", "resumes"
end
