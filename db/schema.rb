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

ActiveRecord::Schema.define(version: 20170413070517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "admin_role_id"
    t.boolean  "deactivated"
  end

  create_table "admins_industries", id: false, force: :cascade do |t|
    t.integer "admin_id",    null: false
    t.integer "industry_id", null: false
    t.index ["admin_id", "industry_id"], name: "index_admins_industries_on_admin_id_and_industry_id", using: :btree
    t.index ["industry_id", "admin_id"], name: "index_admins_industries_on_industry_id_and_admin_id", using: :btree
  end

  create_table "artist_fans", force: :cascade do |t|
    t.integer  "artist_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artist_specialities", force: :cascade do |t|
    t.string   "name"
    t.integer  "industry_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "artist_specialities_artists", id: false, force: :cascade do |t|
    t.integer "artist_id",            null: false
    t.integer "artist_speciality_id", null: false
    t.index ["artist_id", "artist_speciality_id"], name: "artist_index", using: :btree
    t.index ["artist_speciality_id", "artist_id"], name: "artist_speciality_index", using: :btree
  end

  create_table "artists", force: :cascade do |t|
    t.string   "profile_name"
    t.string   "name"
    t.string   "contact_phone_number"
    t.string   "contact_email"
    t.string   "gender"
    t.date     "birthday"
    t.string   "country_of_birth"
    t.string   "profile_pic_uid"
    t.text     "introduction"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.boolean  "verified",             default: false
    t.string   "aasm_state"
    t.string   "slug"
    t.string   "height"
    t.string   "weight"
    t.string   "bust"
    t.string   "hips"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "featured"
    t.index ["parent_id"], name: "index_artists_on_parent_id", using: :btree
    t.index ["parent_type"], name: "index_artists_on_parent_type", using: :btree
    t.index ["slug"], name: "index_artists_on_slug", unique: true, using: :btree
  end

  create_table "artists_blogs", id: false, force: :cascade do |t|
    t.integer "blog_id",   null: false
    t.integer "artist_id", null: false
  end

  create_table "artists_events", id: false, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.integer "event_id",  null: false
  end

  create_table "artists_industries", id: false, force: :cascade do |t|
    t.integer "artist_id",   null: false
    t.integer "industry_id", null: false
    t.index ["artist_id", "industry_id"], name: "index_artists_industries_on_artist_id_and_industry_id", using: :btree
    t.index ["industry_id", "artist_id"], name: "index_artists_industries_on_industry_id_and_artist_id", using: :btree
  end

  create_table "artists_news_stories", id: false, force: :cascade do |t|
    t.integer "news_story_id", null: false
    t.integer "artist_id",     null: false
  end

  create_table "artists_productions", id: false, force: :cascade do |t|
    t.integer "artist_id",     null: false
    t.integer "production_id", null: false
  end

  create_table "artists_songs", id: false, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.integer "song_id",   null: false
  end

  create_table "audio_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "award_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "award_id"
    t.boolean  "accepts_entity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
  end

  create_table "awards", force: :cascade do |t|
    t.string   "name"
    t.integer  "business_id"
    t.text     "details"
    t.string   "image_uid"
    t.string   "country"
    t.integer  "start_year"
    t.integer  "industry_id"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "aasm_state"
    t.index ["slug"], name: "index_awards_on_slug", unique: true, using: :btree
  end

  create_table "awards_blogs", id: false, force: :cascade do |t|
    t.integer "award_id", null: false
    t.integer "blog_id",  null: false
    t.index ["award_id", "blog_id"], name: "index_awards_blogs_on_award_id_and_blog_id", using: :btree
    t.index ["blog_id", "award_id"], name: "index_awards_blogs_on_blog_id_and_award_id", using: :btree
  end

  create_table "awards_events", id: false, force: :cascade do |t|
    t.integer "award_id", null: false
    t.integer "event_id", null: false
    t.index ["award_id", "event_id"], name: "index_awards_events_on_award_id_and_event_id", using: :btree
    t.index ["event_id", "award_id"], name: "index_awards_events_on_event_id_and_award_id", using: :btree
  end

  create_table "awards_life_events", id: false, force: :cascade do |t|
    t.integer "award_id",      null: false
    t.integer "life_event_id", null: false
    t.index ["award_id", "life_event_id"], name: "index_awards_life_events_on_award_id_and_life_event_id", using: :btree
    t.index ["life_event_id", "award_id"], name: "index_awards_life_events_on_life_event_id_and_award_id", using: :btree
  end

  create_table "awards_news_stories", id: false, force: :cascade do |t|
    t.integer "award_id",      null: false
    t.integer "news_story_id", null: false
    t.index ["award_id", "news_story_id"], name: "index_awards_news_stories_on_award_id_and_news_story_id", using: :btree
    t.index ["news_story_id", "award_id"], name: "index_awards_news_stories_on_news_story_id_and_award_id", using: :btree
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.date     "date"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image_uid"
    t.index ["slug"], name: "index_blogs_on_slug", using: :btree
  end

  create_table "blogs_businesses", id: false, force: :cascade do |t|
    t.integer "blog_id",     null: false
    t.integer "business_id", null: false
  end

  create_table "blogs_events", id: false, force: :cascade do |t|
    t.integer "blog_id",  null: false
    t.integer "event_id", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "isbn"
    t.string   "cover_pic_uid"
    t.text     "summary"
    t.integer  "publishing_company_id"
    t.date     "publishing_date"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["slug"], name: "index_books_on_slug", using: :btree
  end

  create_table "books_life_events", id: false, force: :cascade do |t|
    t.integer "life_event_id", null: false
    t.integer "book_id",       null: false
  end

  create_table "business_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "business_fans", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.string   "country"
    t.string   "logo_uid"
    t.text     "company_info"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "business_category_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.boolean  "verified",             default: false
    t.string   "slug"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.text     "physical_location"
    t.string   "phone_number"
    t.string   "email"
    t.string   "working_hours"
    t.boolean  "featured"
    t.boolean  "banned"
    t.index ["parent_id"], name: "index_businesses_on_parent_id", using: :btree
    t.index ["parent_type"], name: "index_businesses_on_parent_type", using: :btree
    t.index ["slug"], name: "index_businesses_on_slug", unique: true, using: :btree
  end

  create_table "businesses_industries", id: false, force: :cascade do |t|
    t.integer "business_id", null: false
    t.integer "industry_id", null: false
    t.index ["business_id", "industry_id"], name: "index_businesses_industries_on_business_id_and_industry_id", using: :btree
    t.index ["industry_id", "business_id"], name: "index_businesses_industries_on_industry_id_and_business_id", using: :btree
  end

  create_table "businesses_news_stories", id: false, force: :cascade do |t|
    t.integer "news_story_id", null: false
    t.integer "business_id",   null: false
  end

  create_table "businesses_productions", id: false, force: :cascade do |t|
    t.integer "business_id",   null: false
    t.integer "production_id", null: false
  end

  create_table "collection_albums", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "visible"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.integer  "collection_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "cover_pic_uid"
    t.date     "album_date"
    t.string   "slug"
    t.string   "aasm_state"
    t.index ["slug"], name: "index_collection_albums_on_slug", using: :btree
  end

  create_table "collection_albums_life_events", id: false, force: :cascade do |t|
    t.integer "collection_album_id", null: false
    t.integer "life_event_id",       null: false
  end

  create_table "collection_entities", id: false, force: :cascade do |t|
    t.integer "collection_album_id"
    t.integer "entity_id"
    t.string  "entity_type"
    t.index ["collection_album_id", "entity_id"], name: "index_collection_entities_on_collection_album_id_and_entity_id", using: :btree
    t.index ["entity_id", "collection_album_id"], name: "index_collection_entities_on_entity_id_and_collection_album_id", using: :btree
  end

  create_table "collection_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "directors_productions", id: false, force: :cascade do |t|
    t.integer "artist_id"
    t.integer "production_id"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.integer  "type_id"
    t.text     "description"
    t.string   "charges"
    t.integer  "venue_id"
    t.date     "date"
    t.string   "aasm_state"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "image_uid"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "time"
    t.boolean  "featured"
    t.date     "enddate"
    t.string   "url"
    t.index ["slug"], name: "index_events_on_slug", using: :btree
  end

  create_table "events_news_stories", id: false, force: :cascade do |t|
    t.integer "news_story_id", null: false
    t.integer "event_id",      null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "gallery_photos", force: :cascade do |t|
    t.string   "image_uid"
    t.string   "caption"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "aasm_state"
  end

  create_table "impressions", force: :cascade do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "industries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "industries_users", id: false, force: :cascade do |t|
    t.integer "user_id",     null: false
    t.integer "industry_id", null: false
    t.index ["industry_id", "user_id"], name: "index_industries_users_on_industry_id_and_user_id", using: :btree
    t.index ["user_id", "industry_id"], name: "index_industries_users_on_user_id_and_industry_id", using: :btree
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "life_event_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "life_events", force: :cascade do |t|
    t.date     "date"
    t.string   "title"
    t.integer  "life_event_category_id"
    t.text     "description"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "duration"
    t.string   "image_uid"
    t.index ["slug"], name: "index_life_events_on_slug", using: :btree
  end

  create_table "life_events_photo_arts", id: false, force: :cascade do |t|
    t.integer "life_event_id", null: false
    t.integer "photo_art_id",  null: false
  end

  create_table "life_events_productions", id: false, force: :cascade do |t|
    t.integer "life_event_id", null: false
    t.integer "production_id", null: false
  end

  create_table "life_events_songs", id: false, force: :cascade do |t|
    t.integer "life_event_id", null: false
    t.integer "song_id",       null: false
  end

  create_table "links", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "news_stories", force: :cascade do |t|
    t.string   "title"
    t.date     "date"
    t.text     "content"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image_uid"
    t.index ["slug"], name: "index_news_stories_on_slug", using: :btree
  end

  create_table "nominees", force: :cascade do |t|
    t.integer  "award_category_id"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "year"
    t.integer  "rank_id",           default: 4
  end

  create_table "page_admins", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "page_id"
    t.string  "page_type"
    t.boolean "admin_accepted", default: false
    t.index ["page_id", "user_id"], name: "index_page_admins_on_page_id_and_user_id", using: :btree
    t.index ["user_id", "page_id"], name: "index_page_admins_on_user_id_and_page_id", using: :btree
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.string   "searchable_type"
    t.integer  "searchable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree
  end

  create_table "photo_arts", force: :cascade do |t|
    t.string   "title"
    t.date     "date"
    t.text     "description"
    t.string   "image_uid"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["slug"], name: "index_photo_arts_on_slug", using: :btree
  end

  create_table "production_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productions", force: :cascade do |t|
    t.string   "cover_picture_uid"
    t.integer  "production_category_id"
    t.string   "title"
    t.integer  "language_id"
    t.integer  "running_time"
    t.date     "release_date"
    t.text     "synopsis"
    t.integer  "director_id"
    t.integer  "production_company_id"
    t.string   "trailer_url"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["slug"], name: "index_productions_on_slug", using: :btree
  end

  create_table "ranks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_ad_positions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_ads", force: :cascade do |t|
    t.string   "name"
    t.string   "image_uid"
    t.text     "script"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "site_ad_position_id"
    t.boolean  "active",              default: true
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slider_images", force: :cascade do |t|
    t.string   "image_uid"
    t.boolean  "active",           default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "left_content"
    t.text     "right_content"
    t.text     "centered_content"
    t.integer  "position"
  end

  create_table "songs", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "lyrics"
    t.string   "audio_url"
    t.integer  "audio_category_id"
    t.string   "video_url"
    t.string   "image_uid"
    t.date     "release_date"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "aasm_state"
    t.string   "slug"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "production_company_id"
    t.index ["slug"], name: "index_songs_on_slug", using: :btree
  end

  create_table "suggested_updates", force: :cascade do |t|
    t.text     "content"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.boolean  "closed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "profile_image_uid"
    t.date     "birthday"
    t.string   "country"
    t.string   "slug"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "email_confirmed"
    t.string   "email_confirmation_token"
    t.integer  "sign_in_count",            default: 0
    t.datetime "last_signed_in"
    t.string   "authentication_token"
    t.string   "provider"
    t.string   "uid"
    t.string   "provider_image_url"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "invitation_token"
    t.integer  "user_role_id"
    t.boolean  "content_provider"
    t.boolean  "newsletter"
    t.boolean  "banned"
    t.boolean  "privacy_accepted"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

end
