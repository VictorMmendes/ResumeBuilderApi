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

ActiveRecord::Schema[8.1].define(version: 2025_11_22_200707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "educations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "current"
    t.string "degree"
    t.date "end_date"
    t.string "institution"
    t.string "location"
    t.bigint "resume_id", null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_educations_on_resume_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.boolean "current"
    t.text "description"
    t.date "end_date"
    t.string "job_title"
    t.string "location"
    t.bigint "resume_id", null: false
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_experiences_on_resume_id"
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "level"
    t.string "name"
    t.bigint "resume_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_languages_on_resume_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.string "job_title"
    t.string "linkedin_url"
    t.string "phone"
    t.text "summary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "website_url"
    t.index ["user_id"], name: "index_resumes_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "level"
    t.string "name"
    t.bigint "resume_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_skills_on_resume_id"
  end

  create_table "softwares", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "level"
    t.string "name"
    t.bigint "resume_id", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_softwares_on_resume_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "educations", "resumes"
  add_foreign_key "experiences", "resumes"
  add_foreign_key "languages", "resumes"
  add_foreign_key "resumes", "users"
  add_foreign_key "skills", "resumes"
  add_foreign_key "softwares", "resumes"
end
