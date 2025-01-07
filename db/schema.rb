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

ActiveRecord::Schema.define(version: 20230510184646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.integer  "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
  add_index "ahoy_events", ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name", using: :btree
  add_index "ahoy_events", ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name", using: :btree

  create_table "banner_images", force: :cascade do |t|
    t.integer  "widht"
    t.integer  "height"
    t.string   "alt"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "element_id"
    t.text     "title_text"
    t.string   "link"
    t.boolean  "link_button"
  end

  create_table "comparable_attributes", force: :cascade do |t|
    t.string   "name"
    t.integer  "spree_taxon_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "comparable_attributes", ["spree_taxon_id"], name: "index_comparable_attributes_on_spree_taxon_id", using: :btree

  create_table "comparator_items", force: :cascade do |t|
    t.integer  "comparator_id"
    t.integer  "spree_variant_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comparator_items", ["comparator_id"], name: "index_comparator_items_on_comparator_id", using: :btree
  add_index "comparator_items", ["spree_variant_id"], name: "index_comparator_items_on_spree_variant_id", using: :btree

  create_table "comparators", force: :cascade do |t|
    t.integer  "spree_user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "comp_token"
  end

  add_index "comparators", ["spree_user_id"], name: "index_comparators_on_spree_user_id", using: :btree

  create_table "comunas", force: :cascade do |t|
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "core_id",     limit: 8
  end

  add_index "comunas", ["province_id"], name: "index_comunas_on_province_id", using: :btree

  create_table "fbpixels", force: :cascade do |t|
    t.string   "pixel_id"
    t.boolean  "active"
    t.boolean  "search"
    t.boolean  "view_content"
    t.boolean  "add_to_cart"
    t.boolean  "initiate_checkout"
    t.boolean  "add_payment_info"
    t.boolean  "purchase"
    t.boolean  "lead_client"
    t.boolean  "complete_registration"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "deleted_at"
  end

  add_index "friendly_id_slugs", ["deleted_at"], name: "index_friendly_id_slugs_on_deleted_at", using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "miele_configs", force: :cascade do |t|
    t.string   "title_oportunities"
    t.datetime "start_oportunities"
    t.datetime "end_oportunities"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "newsletter_subscribers", force: :cascade do |t|
    t.string   "email"
    t.boolean  "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "newsletter_subscribers", ["email"], name: "index_newsletter_subscribers_on_email", unique: true, using: :btree

  create_table "product_comparable_attributes", force: :cascade do |t|
    t.integer  "spree_product_id"
    t.integer  "comparable_attribute_id"
    t.string   "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "product_comparable_attributes", ["comparable_attribute_id"], name: "index_product_comparable_attributes_on_comparable_attribute_id", using: :btree
  add_index "product_comparable_attributes", ["spree_product_id"], name: "index_product_comparable_attributes_on_spree_product_id", using: :btree

  create_table "promotional_banners", force: :cascade do |t|
    t.string   "alt"
    t.string   "image_file_name"
    t.integer  "width"
    t.integer  "height"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "location"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "spree_taxon_id"
    t.string   "title"
    t.string   "link"
    t.string   "mobile_image_file_name"
    t.string   "mobile_image_content_type"
    t.integer  "mobile_image_file_size"
    t.datetime "mobile_image_updated_at"
    t.string   "active"
  end

  add_index "promotional_banners", ["spree_taxon_id"], name: "index_promotional_banners_on_spree_taxon_id", using: :btree

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.integer  "spree_state_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "provinces", ["spree_state_id"], name: "index_provinces_on_spree_state_id", using: :btree

  create_table "quotations", force: :cascade do |t|
    t.integer  "spree_address_id"
    t.integer  "spree_user_id"
    t.integer  "spree_product_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "quotations", ["spree_address_id"], name: "index_quotations_on_spree_address_id", using: :btree
  add_index "quotations", ["spree_product_id"], name: "index_quotations_on_spree_product_id", using: :btree
  add_index "quotations", ["spree_user_id"], name: "index_quotations_on_spree_user_id", using: :btree

  create_table "specific_attributes", force: :cascade do |t|
    t.boolean  "mandatory"
    t.string   "channel"
    t.boolean  "can_retire"
    t.boolean  "can_ship"
    t.string   "category"
    t.boolean  "built_in"
    t.boolean  "instalation"
    t.boolean  "outlet"
    t.text     "specs"
    t.text     "features"
    t.text     "technical_specs"
    t.text     "product_functions"
    t.text     "drink"
    t.text     "basket_design"
    t.text     "wash_program"
    t.text     "dry_program"
    t.text     "care"
    t.text     "security"
    t.text     "sustain"
    t.text     "accessories"
    t.integer  "spree_product_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "specific_attributes", ["spree_product_id"], name: "index_specific_attributes_on_spree_product_id", using: :btree

  create_table "spree_addresses", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.string   "company"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "comuna_id"
    t.string   "complementary_data"
    t.string   "rut"
    t.integer  "street_type"
    t.string   "number"
    t.string   "apartment"
  end

  add_index "spree_addresses", ["comuna_id"], name: "index_spree_addresses_on_comuna_id", using: :btree
  add_index "spree_addresses", ["country_id"], name: "index_spree_addresses_on_country_id", using: :btree
  add_index "spree_addresses", ["firstname"], name: "index_addresses_on_firstname", using: :btree
  add_index "spree_addresses", ["lastname"], name: "index_addresses_on_lastname", using: :btree
  add_index "spree_addresses", ["state_id"], name: "index_spree_addresses_on_state_id", using: :btree

  create_table "spree_adjustments", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.decimal  "amount",          precision: 10, scale: 2
    t.string   "label"
    t.boolean  "mandatory"
    t.boolean  "eligible",                                 default: true
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "state"
    t.integer  "order_id",                                                 null: false
    t.boolean  "included",                                 default: false
  end

  add_index "spree_adjustments", ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type", using: :btree
  add_index "spree_adjustments", ["eligible"], name: "index_spree_adjustments_on_eligible", using: :btree
  add_index "spree_adjustments", ["order_id"], name: "index_spree_adjustments_on_order_id", using: :btree
  add_index "spree_adjustments", ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type", using: :btree

  create_table "spree_assets", force: :cascade do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    limit: 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spree_assets", ["position"], name: "index_spree_assets_on_position", using: :btree
  add_index "spree_assets", ["viewable_id"], name: "index_assets_on_viewable_id", using: :btree
  add_index "spree_assets", ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type", using: :btree

  create_table "spree_calculators", force: :cascade do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "preferences"
    t.datetime "deleted_at"
  end

  add_index "spree_calculators", ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type", using: :btree
  add_index "spree_calculators", ["deleted_at"], name: "index_spree_calculators_on_deleted_at", using: :btree
  add_index "spree_calculators", ["id", "type"], name: "index_spree_calculators_on_id_and_type", using: :btree

  create_table "spree_comment_types", force: :cascade do |t|
    t.string   "name"
    t.string   "applies_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_comments", force: :cascade do |t|
    t.string   "title",            limit: 50
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_type_id"
  end

  add_index "spree_comments", ["commentable_id"], name: "index_spree_comments_on_commentable_id", using: :btree
  add_index "spree_comments", ["commentable_type"], name: "index_spree_comments_on_commentable_type", using: :btree
  add_index "spree_comments", ["user_id"], name: "index_spree_comments_on_user_id", using: :btree

  create_table "spree_countries", force: :cascade do |t|
    t.string   "iso_name"
    t.string   "iso"
    t.string   "iso3"
    t.string   "name"
    t.integer  "numcode"
    t.boolean  "states_required", default: false
    t.datetime "updated_at"
  end

  create_table "spree_credit_cards", force: :cascade do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "last_digits"
    t.integer  "address_id"
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "name"
    t.integer  "user_id"
    t.integer  "payment_method_id"
    t.boolean  "default",                     default: false, null: false
  end

  add_index "spree_credit_cards", ["address_id"], name: "index_spree_credit_cards_on_address_id", using: :btree
  add_index "spree_credit_cards", ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id", using: :btree
  add_index "spree_credit_cards", ["user_id"], name: "index_spree_credit_cards_on_user_id", using: :btree

  create_table "spree_customer_returns", force: :cascade do |t|
    t.string   "number"
    t.integer  "stock_location_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "spree_feedback_reviews", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "review_id",                 null: false
    t.integer  "rating",     default: 0
    t.text     "comment"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "locale",     default: "en"
  end

  add_index "spree_feedback_reviews", ["review_id"], name: "index_spree_feedback_reviews_on_review_id", using: :btree
  add_index "spree_feedback_reviews", ["user_id"], name: "index_spree_feedback_reviews_on_user_id", using: :btree

  create_table "spree_gateways", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      default: true
    t.string   "environment", default: "development"
    t.string   "server",      default: "test"
    t.boolean  "test_mode",   default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "preferences"
  end

  add_index "spree_gateways", ["active"], name: "index_spree_gateways_on_active", using: :btree
  add_index "spree_gateways", ["test_mode"], name: "index_spree_gateways_on_test_mode", using: :btree

  create_table "spree_inventory_units", force: :cascade do |t|
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "shipment_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "pending",      default: true
    t.integer  "line_item_id"
  end

  add_index "spree_inventory_units", ["line_item_id"], name: "index_spree_inventory_units_on_line_item_id", using: :btree
  add_index "spree_inventory_units", ["order_id"], name: "index_inventory_units_on_order_id", using: :btree
  add_index "spree_inventory_units", ["shipment_id"], name: "index_inventory_units_on_shipment_id", using: :btree
  add_index "spree_inventory_units", ["variant_id"], name: "index_inventory_units_on_variant_id", using: :btree

  create_table "spree_line_items", force: :cascade do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                                                            null: false
    t.decimal  "price",                        precision: 10, scale: 2,               null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.string   "currency"
    t.decimal  "cost_price",                   precision: 10, scale: 2
    t.integer  "tax_category_id"
    t.decimal  "adjustment_total",             precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total",         precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",           precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",               precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "taxable_adjustment_total",     precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "non_taxable_adjustment_total", precision: 10, scale: 2, default: 0.0, null: false
    t.boolean  "instalation"
  end

  add_index "spree_line_items", ["order_id"], name: "index_spree_line_items_on_order_id", using: :btree
  add_index "spree_line_items", ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id", using: :btree
  add_index "spree_line_items", ["variant_id"], name: "index_spree_line_items_on_variant_id", using: :btree

  create_table "spree_log_entries", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "spree_log_entries", ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type", using: :btree

  create_table "spree_option_type_prototypes", force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  add_index "spree_option_type_prototypes", ["option_type_id"], name: "index_spree_option_type_prototypes_on_option_type_id", using: :btree
  add_index "spree_option_type_prototypes", ["prototype_id", "option_type_id"], name: "index_option_types_prototypes_on_prototype_and_option_type", using: :btree

  create_table "spree_option_types", force: :cascade do |t|
    t.string   "name",         limit: 100
    t.string   "presentation", limit: 100
    t.integer  "position",                 default: 0, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "spree_option_types", ["name"], name: "index_spree_option_types_on_name", using: :btree
  add_index "spree_option_types", ["position"], name: "index_spree_option_types_on_position", using: :btree

  create_table "spree_option_value_variants", force: :cascade do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_value_variants", ["option_value_id"], name: "index_spree_option_value_variants_on_option_value_id", using: :btree
  add_index "spree_option_value_variants", ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id", using: :btree

  create_table "spree_option_values", force: :cascade do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_option_values", ["name"], name: "index_spree_option_values_on_name", using: :btree
  add_index "spree_option_values", ["option_type_id"], name: "index_spree_option_values_on_option_type_id", using: :btree
  add_index "spree_option_values", ["position"], name: "index_spree_option_values_on_position", using: :btree

  create_table "spree_order_promotions", force: :cascade do |t|
    t.integer "order_id"
    t.integer "promotion_id"
  end

  add_index "spree_order_promotions", ["order_id"], name: "index_spree_order_promotions_on_order_id", using: :btree
  add_index "spree_order_promotions", ["promotion_id", "order_id"], name: "index_spree_order_promotions_on_promotion_id_and_order_id", using: :btree

  create_table "spree_orders", force: :cascade do |t|
    t.string   "number",                       limit: 32
    t.decimal  "item_total",                              precision: 10, scale: 2, default: 0.0,       null: false
    t.decimal  "total",                                   precision: 10, scale: 2, default: 0.0,       null: false
    t.string   "state"
    t.decimal  "adjustment_total",                        precision: 10, scale: 2, default: 0.0,       null: false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                           precision: 10, scale: 2, default: 0.0
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.string   "currency"
    t.string   "last_ip_address"
    t.integer  "created_by_id"
    t.decimal  "shipment_total",                          precision: 10, scale: 2, default: 0.0,       null: false
    t.decimal  "additional_tax_total",                    precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                             precision: 10, scale: 2, default: 0.0
    t.string   "channel",                                                          default: "spree"
    t.decimal  "included_tax_total",                      precision: 10, scale: 2, default: 0.0,       null: false
    t.integer  "item_count",                                                       default: 0
    t.integer  "approver_id"
    t.datetime "approved_at"
    t.boolean  "confirmation_delivered",                                           default: false
    t.boolean  "considered_risky",                                                 default: false
    t.string   "guest_token"
    t.datetime "canceled_at"
    t.integer  "canceler_id"
    t.integer  "store_id"
    t.integer  "state_lock_version",                                               default: 0,         null: false
    t.decimal  "taxable_adjustment_total",                precision: 10, scale: 2, default: 0.0,       null: false
    t.decimal  "non_taxable_adjustment_total",            precision: 10, scale: 2, default: 0.0,       null: false
    t.string   "tbk_token",                                                        default: ""
    t.string   "webpay_data",                                                      default: ""
    t.string   "tbk_transaction_id",                                               default: ""
    t.string   "document_type",                                                    default: "factura"
    t.boolean  "webpay_nullify",                                                   default: false
    t.integer  "visit_id"
    t.boolean  "viewed",                                                           default: false
    t.boolean  "recovered",                                                        default: false
    t.boolean  "send_to_api",                                                      default: false
    t.datetime "deleted_at"
    t.string   "miele_state"
    t.boolean  "instalation",                                                      default: false
    t.integer  "instalation_value"
    t.string   "tracking_info"
    t.boolean  "send_to_b2b",                                                      default: false
    t.string   "folio_b2b"
  end

  add_index "spree_orders", ["approver_id"], name: "index_spree_orders_on_approver_id", using: :btree
  add_index "spree_orders", ["bill_address_id"], name: "index_spree_orders_on_bill_address_id", using: :btree
  add_index "spree_orders", ["canceler_id"], name: "index_spree_orders_on_canceler_id", using: :btree
  add_index "spree_orders", ["completed_at"], name: "index_spree_orders_on_completed_at", using: :btree
  add_index "spree_orders", ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered", using: :btree
  add_index "spree_orders", ["considered_risky"], name: "index_spree_orders_on_considered_risky", using: :btree
  add_index "spree_orders", ["created_by_id"], name: "index_spree_orders_on_created_by_id", using: :btree
  add_index "spree_orders", ["deleted_at"], name: "index_spree_orders_on_deleted_at", using: :btree
  add_index "spree_orders", ["guest_token"], name: "index_spree_orders_on_guest_token", using: :btree
  add_index "spree_orders", ["miele_state"], name: "index_spree_orders_on_miele_state", using: :btree
  add_index "spree_orders", ["number"], name: "index_spree_orders_on_number", using: :btree
  add_index "spree_orders", ["ship_address_id"], name: "index_spree_orders_on_ship_address_id", using: :btree
  add_index "spree_orders", ["store_id"], name: "index_spree_orders_on_store_id", using: :btree
  add_index "spree_orders", ["user_id", "created_by_id"], name: "index_spree_orders_on_user_id_and_created_by_id", using: :btree
  add_index "spree_orders", ["visit_id"], name: "index_spree_orders_on_visit_id", using: :btree

  create_table "spree_payment_capture_events", force: :cascade do |t|
    t.decimal  "amount",     precision: 10, scale: 2, default: 0.0
    t.integer  "payment_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "spree_payment_capture_events", ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id", using: :btree

  create_table "spree_payment_methods", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",       default: true
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "display_on",   default: "both"
    t.boolean  "auto_capture"
    t.text     "preferences"
    t.integer  "position",     default: 0
  end

  add_index "spree_payment_methods", ["id", "type"], name: "index_spree_payment_methods_on_id_and_type", using: :btree

  create_table "spree_payments", force: :cascade do |t|
    t.decimal  "amount",               precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "number"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
  end

  add_index "spree_payments", ["number"], name: "index_spree_payments_on_number", using: :btree
  add_index "spree_payments", ["order_id"], name: "index_spree_payments_on_order_id", using: :btree
  add_index "spree_payments", ["payment_method_id"], name: "index_spree_payments_on_payment_method_id", using: :btree
  add_index "spree_payments", ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type", using: :btree

  create_table "spree_preferences", force: :cascade do |t|
    t.text     "value"
    t.string   "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "spree_preferences", ["key"], name: "index_spree_preferences_on_key", unique: true, using: :btree

  create_table "spree_prices", force: :cascade do |t|
    t.integer  "variant_id",                                 null: false
    t.decimal  "amount",            precision: 10, scale: 2
    t.string   "currency"
    t.datetime "deleted_at"
    t.decimal  "offer_price",       precision: 10, scale: 2
    t.date     "offer_price_start"
    t.date     "offer_price_end"
  end

  add_index "spree_prices", ["deleted_at"], name: "index_spree_prices_on_deleted_at", using: :btree
  add_index "spree_prices", ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency", using: :btree
  add_index "spree_prices", ["variant_id"], name: "index_spree_prices_on_variant_id", using: :btree

  create_table "spree_product_option_types", force: :cascade do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_product_option_types", ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id", using: :btree
  add_index "spree_product_option_types", ["position"], name: "index_spree_product_option_types_on_position", using: :btree
  add_index "spree_product_option_types", ["product_id"], name: "index_spree_product_option_types_on_product_id", using: :btree

  create_table "spree_product_promotion_rules", force: :cascade do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_product_promotion_rules", ["product_id"], name: "index_products_promotion_rules_on_product_id", using: :btree
  add_index "spree_product_promotion_rules", ["promotion_rule_id", "product_id"], name: "index_products_promotion_rules_on_promotion_rule_and_product", using: :btree

  create_table "spree_product_properties", force: :cascade do |t|
    t.string   "value"
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "position",    default: 0
  end

  add_index "spree_product_properties", ["position"], name: "index_spree_product_properties_on_position", using: :btree
  add_index "spree_product_properties", ["product_id"], name: "index_product_properties_on_product_id", using: :btree
  add_index "spree_product_properties", ["property_id"], name: "index_spree_product_properties_on_property_id", using: :btree

  create_table "spree_products", force: :cascade do |t|
    t.string   "name",                                         default: "",    null: false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "slug"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.boolean  "promotionable",                                default: true
    t.string   "meta_title"
    t.datetime "discontinue_on"
    t.decimal  "avg_rating",           precision: 7, scale: 5, default: 0.0,   null: false
    t.integer  "reviews_count",                                default: 0,     null: false
    t.boolean  "featured",                                     default: false
    t.string   "sensitive_name",                               default: ""
    t.integer  "viewed_count",                                 default: 0
    t.string   "brand"
    t.text     "long_description"
    t.boolean  "service",                                      default: false
    t.string   "disclaimer"
  end

  add_index "spree_products", ["available_on"], name: "index_spree_products_on_available_on", using: :btree
  add_index "spree_products", ["deleted_at"], name: "index_spree_products_on_deleted_at", using: :btree
  add_index "spree_products", ["discontinue_on"], name: "index_spree_products_on_discontinue_on", using: :btree
  add_index "spree_products", ["name"], name: "index_spree_products_on_name", using: :btree
  add_index "spree_products", ["shipping_category_id"], name: "index_spree_products_on_shipping_category_id", using: :btree
  add_index "spree_products", ["slug"], name: "index_spree_products_on_slug", unique: true, using: :btree
  add_index "spree_products", ["tax_category_id"], name: "index_spree_products_on_tax_category_id", using: :btree

  create_table "spree_products_taxons", force: :cascade do |t|
    t.integer "product_id"
    t.integer "taxon_id"
    t.integer "position"
  end

  add_index "spree_products_taxons", ["position"], name: "index_spree_products_taxons_on_position", using: :btree
  add_index "spree_products_taxons", ["product_id"], name: "index_spree_products_taxons_on_product_id", using: :btree
  add_index "spree_products_taxons", ["taxon_id"], name: "index_spree_products_taxons_on_taxon_id", using: :btree

  create_table "spree_promotion_action_line_items", force: :cascade do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            default: 1
  end

  add_index "spree_promotion_action_line_items", ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id", using: :btree
  add_index "spree_promotion_action_line_items", ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id", using: :btree

  create_table "spree_promotion_actions", force: :cascade do |t|
    t.integer  "promotion_id"
    t.integer  "position"
    t.string   "type"
    t.datetime "deleted_at"
  end

  add_index "spree_promotion_actions", ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at", using: :btree
  add_index "spree_promotion_actions", ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type", using: :btree
  add_index "spree_promotion_actions", ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id", using: :btree

  create_table "spree_promotion_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "spree_promotion_rule_taxons", force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rule_taxons", ["promotion_rule_id"], name: "index_spree_promotion_rule_taxons_on_promotion_rule_id", using: :btree
  add_index "spree_promotion_rule_taxons", ["taxon_id"], name: "index_spree_promotion_rule_taxons_on_taxon_id", using: :btree

  create_table "spree_promotion_rule_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rule_users", ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id", using: :btree
  add_index "spree_promotion_rule_users", ["user_id", "promotion_rule_id"], name: "index_promotion_rules_users_on_user_id_and_promotion_rule_id", using: :btree

  create_table "spree_promotion_rules", force: :cascade do |t|
    t.integer  "promotion_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "code"
    t.text     "preferences"
  end

  add_index "spree_promotion_rules", ["product_group_id"], name: "index_promotion_rules_on_product_group_id", using: :btree
  add_index "spree_promotion_rules", ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id", using: :btree
  add_index "spree_promotion_rules", ["user_id"], name: "index_promotion_rules_on_user_id", using: :btree

  create_table "spree_promotions", force: :cascade do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy",          default: "all"
    t.string   "code"
    t.boolean  "advertise",             default: false
    t.string   "path"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "promotion_category_id"
  end

  add_index "spree_promotions", ["advertise"], name: "index_spree_promotions_on_advertise", using: :btree
  add_index "spree_promotions", ["code"], name: "index_spree_promotions_on_code", using: :btree
  add_index "spree_promotions", ["expires_at"], name: "index_spree_promotions_on_expires_at", using: :btree
  add_index "spree_promotions", ["id", "type"], name: "index_spree_promotions_on_id_and_type", using: :btree
  add_index "spree_promotions", ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id", using: :btree
  add_index "spree_promotions", ["starts_at"], name: "index_spree_promotions_on_starts_at", using: :btree

  create_table "spree_properties", force: :cascade do |t|
    t.string   "name"
    t.string   "presentation", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "spree_properties", ["name"], name: "index_spree_properties_on_name", using: :btree

  create_table "spree_property_prototypes", force: :cascade do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  add_index "spree_property_prototypes", ["prototype_id", "property_id"], name: "index_properties_prototypes_on_prototype_and_property", using: :btree

  create_table "spree_prototype_taxons", force: :cascade do |t|
    t.integer "taxon_id"
    t.integer "prototype_id"
  end

  add_index "spree_prototype_taxons", ["prototype_id", "taxon_id"], name: "index_spree_prototype_taxons_on_prototype_id_and_taxon_id", using: :btree
  add_index "spree_prototype_taxons", ["taxon_id"], name: "index_spree_prototype_taxons_on_taxon_id", using: :btree

  create_table "spree_prototypes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_refund_reasons", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "spree_refunds", force: :cascade do |t|
    t.integer  "payment_id"
    t.decimal  "amount",           precision: 10, scale: 2, default: 0.0, null: false
    t.string   "transaction_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "refund_reason_id"
    t.integer  "reimbursement_id"
  end

  add_index "spree_refunds", ["refund_reason_id"], name: "index_refunds_on_refund_reason_id", using: :btree

  create_table "spree_reimbursement_credits", force: :cascade do |t|
    t.decimal "amount",           precision: 10, scale: 2, default: 0.0, null: false
    t.integer "reimbursement_id"
    t.integer "creditable_id"
    t.string  "creditable_type"
  end

  create_table "spree_reimbursement_types", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "type"
  end

  add_index "spree_reimbursement_types", ["type"], name: "index_spree_reimbursement_types_on_type", using: :btree

  create_table "spree_reimbursements", force: :cascade do |t|
    t.string   "number"
    t.string   "reimbursement_status"
    t.integer  "customer_return_id"
    t.integer  "order_id"
    t.decimal  "total",                precision: 10, scale: 2
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "spree_reimbursements", ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id", using: :btree
  add_index "spree_reimbursements", ["order_id"], name: "index_spree_reimbursements_on_order_id", using: :btree

  create_table "spree_relation_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "applies_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_relations", force: :cascade do |t|
    t.integer  "relation_type_id"
    t.integer  "relatable_id"
    t.string   "relatable_type"
    t.integer  "related_to_id"
    t.string   "related_to_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "discount_amount",  precision: 8, scale: 2, default: 0.0
    t.integer  "position"
  end

  create_table "spree_return_authorization_reasons", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.boolean  "mutable",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "spree_return_authorizations", force: :cascade do |t|
    t.string   "number"
    t.string   "state"
    t.integer  "order_id"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_location_id"
    t.integer  "return_authorization_reason_id"
  end

  add_index "spree_return_authorizations", ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id", using: :btree

  create_table "spree_return_items", force: :cascade do |t|
    t.integer  "return_authorization_id"
    t.integer  "inventory_unit_id"
    t.integer  "exchange_variant_id"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.decimal  "pre_tax_amount",                  precision: 12, scale: 4, default: 0.0,  null: false
    t.decimal  "included_tax_total",              precision: 12, scale: 4, default: 0.0,  null: false
    t.decimal  "additional_tax_total",            precision: 12, scale: 4, default: 0.0,  null: false
    t.string   "reception_status"
    t.string   "acceptance_status"
    t.integer  "customer_return_id"
    t.integer  "reimbursement_id"
    t.integer  "exchange_inventory_unit_id"
    t.text     "acceptance_status_errors"
    t.integer  "preferred_reimbursement_type_id"
    t.integer  "override_reimbursement_type_id"
    t.boolean  "resellable",                                               default: true, null: false
  end

  add_index "spree_return_items", ["customer_return_id"], name: "index_return_items_on_customer_return_id", using: :btree
  add_index "spree_return_items", ["exchange_inventory_unit_id"], name: "index_spree_return_items_on_exchange_inventory_unit_id", using: :btree

  create_table "spree_reviews", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "location"
    t.integer  "rating"
    t.text     "title"
    t.text     "review"
    t.boolean  "approved",        default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "locale",          default: "en"
    t.boolean  "show_identifier", default: true
  end

  add_index "spree_reviews", ["show_identifier"], name: "index_spree_reviews_on_show_identifier", using: :btree

  create_table "spree_role_users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_role_users", ["role_id"], name: "index_spree_role_users_on_role_id", using: :btree
  add_index "spree_role_users", ["user_id"], name: "index_spree_role_users_on_user_id", using: :btree

  create_table "spree_roles", force: :cascade do |t|
    t.string "name"
  end

  add_index "spree_roles", ["name"], name: "index_spree_roles_on_name", using: :btree

  create_table "spree_shipments", force: :cascade do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",                         precision: 10, scale: 2, default: 0.0
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "address_id"
    t.string   "state"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.integer  "stock_location_id"
    t.decimal  "adjustment_total",             precision: 10, scale: 2, default: 0.0
    t.decimal  "additional_tax_total",         precision: 10, scale: 2, default: 0.0
    t.decimal  "promo_total",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "included_tax_total",           precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "pre_tax_amount",               precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "taxable_adjustment_total",     precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "non_taxable_adjustment_total", precision: 10, scale: 2, default: 0.0, null: false
    t.string   "alternative_tracking"
  end

  add_index "spree_shipments", ["address_id"], name: "index_spree_shipments_on_address_id", using: :btree
  add_index "spree_shipments", ["number"], name: "index_shipments_on_number", using: :btree
  add_index "spree_shipments", ["order_id"], name: "index_spree_shipments_on_order_id", using: :btree
  add_index "spree_shipments", ["stock_location_id"], name: "index_spree_shipments_on_stock_location_id", using: :btree

  create_table "spree_shipping_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "spree_shipping_categories", ["name"], name: "index_spree_shipping_categories_on_name", using: :btree

  create_table "spree_shipping_method_categories", force: :cascade do |t|
    t.integer  "shipping_method_id",   null: false
    t.integer  "shipping_category_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "spree_shipping_method_categories", ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true, using: :btree
  add_index "spree_shipping_method_categories", ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id", using: :btree

  create_table "spree_shipping_method_zones", force: :cascade do |t|
    t.integer "shipping_method_id"
    t.integer "zone_id"
  end

  create_table "spree_shipping_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "display_on"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "tracking_url"
    t.string   "admin_name"
    t.integer  "tax_category_id"
    t.string   "code"
  end

  add_index "spree_shipping_methods", ["deleted_at"], name: "index_spree_shipping_methods_on_deleted_at", using: :btree
  add_index "spree_shipping_methods", ["tax_category_id"], name: "index_spree_shipping_methods_on_tax_category_id", using: :btree

  create_table "spree_shipping_rates", force: :cascade do |t|
    t.integer  "shipment_id"
    t.integer  "shipping_method_id"
    t.boolean  "selected",                                    default: false
    t.decimal  "cost",               precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "tax_rate_id"
  end

  add_index "spree_shipping_rates", ["selected"], name: "index_spree_shipping_rates_on_selected", using: :btree
  add_index "spree_shipping_rates", ["shipment_id", "shipping_method_id"], name: "spree_shipping_rates_join_index", unique: true, using: :btree
  add_index "spree_shipping_rates", ["tax_rate_id"], name: "index_spree_shipping_rates_on_tax_rate_id", using: :btree

  create_table "spree_skrill_transactions", force: :cascade do |t|
    t.string   "email"
    t.float    "amount"
    t.string   "currency"
    t.integer  "transaction_id"
    t.integer  "customer_id"
    t.string   "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spree_state_changes", force: :cascade do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.string   "stateful_type"
    t.string   "next_state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "spree_state_changes", ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type", using: :btree

  create_table "spree_states", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.integer  "country_id"
    t.datetime "updated_at"
    t.integer  "mda_a"
    t.integer  "mda_b"
    t.integer  "mda_c"
    t.integer  "sda_a"
    t.integer  "sda_b"
    t.integer  "sda_c"
    t.integer  "pai_a"
    t.integer  "inst_a"
    t.integer  "inst_b"
    t.integer  "inst_c"
  end

  add_index "spree_states", ["country_id"], name: "index_spree_states_on_country_id", using: :btree

  create_table "spree_stock_items", force: :cascade do |t|
    t.integer  "stock_location_id"
    t.integer  "variant_id"
    t.integer  "count_on_hand",     default: 0,     null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "backorderable",     default: false
    t.datetime "deleted_at"
  end

  add_index "spree_stock_items", ["backorderable"], name: "index_spree_stock_items_on_backorderable", using: :btree
  add_index "spree_stock_items", ["deleted_at"], name: "index_spree_stock_items_on_deleted_at", using: :btree
  add_index "spree_stock_items", ["stock_location_id", "variant_id"], name: "stock_item_by_loc_and_var_id", using: :btree
  add_index "spree_stock_items", ["variant_id"], name: "index_spree_stock_items_on_variant_id", using: :btree

  create_table "spree_stock_locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "default",                default: false, null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "state_name"
    t.integer  "country_id"
    t.string   "zipcode"
    t.string   "phone"
    t.boolean  "active",                 default: true
    t.boolean  "backorderable_default",  default: false
    t.boolean  "propagate_all_variants", default: true
    t.string   "admin_name"
  end

  add_index "spree_stock_locations", ["active"], name: "index_spree_stock_locations_on_active", using: :btree
  add_index "spree_stock_locations", ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default", using: :btree
  add_index "spree_stock_locations", ["country_id"], name: "index_spree_stock_locations_on_country_id", using: :btree
  add_index "spree_stock_locations", ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants", using: :btree
  add_index "spree_stock_locations", ["state_id"], name: "index_spree_stock_locations_on_state_id", using: :btree

  create_table "spree_stock_movements", force: :cascade do |t|
    t.integer  "stock_item_id"
    t.integer  "quantity",        default: 0
    t.string   "action"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "originator_id"
    t.string   "originator_type"
  end

  add_index "spree_stock_movements", ["stock_item_id"], name: "index_spree_stock_movements_on_stock_item_id", using: :btree

  create_table "spree_stock_transfers", force: :cascade do |t|
    t.string   "type"
    t.string   "reference"
    t.integer  "source_location_id"
    t.integer  "destination_location_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "number"
  end

  add_index "spree_stock_transfers", ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id", using: :btree
  add_index "spree_stock_transfers", ["number"], name: "index_spree_stock_transfers_on_number", using: :btree
  add_index "spree_stock_transfers", ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id", using: :btree

  create_table "spree_store_credit_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spree_store_credit_events", force: :cascade do |t|
    t.integer  "store_credit_id",                                          null: false
    t.string   "action",                                                   null: false
    t.decimal  "amount",             precision: 8, scale: 2
    t.string   "authorization_code",                                       null: false
    t.decimal  "user_total_amount",  precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "originator_id"
    t.string   "originator_type"
    t.datetime "deleted_at"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "spree_store_credit_events", ["originator_id", "originator_type"], name: "spree_store_credit_events_originator", using: :btree
  add_index "spree_store_credit_events", ["store_credit_id"], name: "index_spree_store_credit_events_on_store_credit_id", using: :btree

  create_table "spree_store_credit_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "spree_store_credit_types", ["priority"], name: "index_spree_store_credit_types_on_priority", using: :btree

  create_table "spree_store_credits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "created_by_id"
    t.decimal  "amount",            precision: 8, scale: 2, default: 0.0, null: false
    t.decimal  "amount_used",       precision: 8, scale: 2, default: 0.0, null: false
    t.text     "memo"
    t.datetime "deleted_at"
    t.string   "currency"
    t.decimal  "amount_authorized", precision: 8, scale: 2, default: 0.0, null: false
    t.integer  "originator_id"
    t.string   "originator_type"
    t.integer  "type_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "spree_store_credits", ["deleted_at"], name: "index_spree_store_credits_on_deleted_at", using: :btree
  add_index "spree_store_credits", ["originator_id", "originator_type"], name: "spree_store_credits_originator", using: :btree
  add_index "spree_store_credits", ["type_id"], name: "index_spree_store_credits_on_type_id", using: :btree
  add_index "spree_store_credits", ["user_id"], name: "index_spree_store_credits_on_user_id", using: :btree

  create_table "spree_stores", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "meta_description"
    t.text     "meta_keywords"
    t.string   "seo_title"
    t.string   "mail_from_address"
    t.string   "default_currency"
    t.string   "code"
    t.boolean  "default",               default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "show_newsletter_popup"
  end

  add_index "spree_stores", ["code"], name: "index_spree_stores_on_code", using: :btree
  add_index "spree_stores", ["default"], name: "index_spree_stores_on_default", using: :btree
  add_index "spree_stores", ["url"], name: "index_spree_stores_on_url", using: :btree

  create_table "spree_tax_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_default",  default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "tax_code"
  end

  add_index "spree_tax_categories", ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at", using: :btree
  add_index "spree_tax_categories", ["is_default"], name: "index_spree_tax_categories_on_is_default", using: :btree

  create_table "spree_tax_rates", force: :cascade do |t|
    t.decimal  "amount",             precision: 8, scale: 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.boolean  "included_in_price",                          default: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "name"
    t.boolean  "show_rate_in_label",                         default: true
    t.datetime "deleted_at"
  end

  add_index "spree_tax_rates", ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at", using: :btree
  add_index "spree_tax_rates", ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price", using: :btree
  add_index "spree_tax_rates", ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label", using: :btree
  add_index "spree_tax_rates", ["tax_category_id"], name: "index_spree_tax_rates_on_tax_category_id", using: :btree
  add_index "spree_tax_rates", ["zone_id"], name: "index_spree_tax_rates_on_zone_id", using: :btree

  create_table "spree_taxonomies", force: :cascade do |t|
    t.string   "name",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "position",   default: 0
  end

  add_index "spree_taxonomies", ["position"], name: "index_spree_taxonomies_on_position", using: :btree

  create_table "spree_taxons", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "position",          default: 0
    t.string   "name",                              null: false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "depth"
    t.boolean  "featured",          default: false
    t.string   "category_home_id"
  end

  add_index "spree_taxons", ["lft"], name: "index_spree_taxons_on_lft", using: :btree
  add_index "spree_taxons", ["name"], name: "index_spree_taxons_on_name", using: :btree
  add_index "spree_taxons", ["parent_id"], name: "index_taxons_on_parent_id", using: :btree
  add_index "spree_taxons", ["permalink"], name: "index_taxons_on_permalink", using: :btree
  add_index "spree_taxons", ["position"], name: "index_spree_taxons_on_position", using: :btree
  add_index "spree_taxons", ["rgt"], name: "index_spree_taxons_on_rgt", using: :btree
  add_index "spree_taxons", ["taxonomy_id"], name: "index_taxons_on_taxonomy_id", using: :btree

  create_table "spree_trackers", force: :cascade do |t|
    t.string   "analytics_id"
    t.boolean  "active",       default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "spree_trackers", ["active"], name: "index_spree_trackers_on_active", using: :btree

  create_table "spree_users", force: :cascade do |t|
    t.string   "encrypted_password",     limit: 128
    t.string   "password_salt",          limit: 128
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                      default: 0, null: false
    t.integer  "failed_attempts",                    default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "spree_api_key",          limit: 48
    t.datetime "remember_created_at"
    t.datetime "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "name"
    t.string   "last_name"
    t.string   "rut"
    t.string   "api_key"
  end

  add_index "spree_users", ["bill_address_id"], name: "index_spree_users_on_bill_address_id", using: :btree
  add_index "spree_users", ["deleted_at"], name: "index_spree_users_on_deleted_at", using: :btree
  add_index "spree_users", ["email"], name: "email_idx_unique", unique: true, using: :btree
  add_index "spree_users", ["ship_address_id"], name: "index_spree_users_on_ship_address_id", using: :btree
  add_index "spree_users", ["spree_api_key"], name: "index_spree_users_on_spree_api_key", using: :btree

  create_table "spree_variants", force: :cascade do |t|
    t.string   "sku",                                                  default: "",    null: false
    t.decimal  "weight",                      precision: 8,  scale: 2, default: 0.0
    t.decimal  "height",                      precision: 8,  scale: 2
    t.decimal  "width",                       precision: 8,  scale: 2
    t.decimal  "depth",                       precision: 8,  scale: 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                            default: false
    t.integer  "product_id"
    t.decimal  "cost_price",                  precision: 10, scale: 2
    t.integer  "position"
    t.string   "cost_currency"
    t.boolean  "track_inventory",                                      default: true
    t.integer  "tax_category_id"
    t.datetime "updated_at"
    t.integer  "stock_items_count",                                    default: 0,     null: false
    t.datetime "discontinue_on"
    t.integer  "core_id",           limit: 8
  end

  add_index "spree_variants", ["deleted_at"], name: "index_spree_variants_on_deleted_at", using: :btree
  add_index "spree_variants", ["discontinue_on"], name: "index_spree_variants_on_discontinue_on", using: :btree
  add_index "spree_variants", ["is_master"], name: "index_spree_variants_on_is_master", using: :btree
  add_index "spree_variants", ["position"], name: "index_spree_variants_on_position", using: :btree
  add_index "spree_variants", ["product_id"], name: "index_spree_variants_on_product_id", using: :btree
  add_index "spree_variants", ["sku"], name: "index_spree_variants_on_sku", using: :btree
  add_index "spree_variants", ["tax_category_id"], name: "index_spree_variants_on_tax_category_id", using: :btree
  add_index "spree_variants", ["track_inventory"], name: "index_spree_variants_on_track_inventory", using: :btree

  create_table "spree_zone_members", force: :cascade do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "spree_zone_members", ["zone_id"], name: "index_spree_zone_members_on_zone_id", using: :btree
  add_index "spree_zone_members", ["zoneable_id", "zoneable_type"], name: "index_spree_zone_members_on_zoneable_id_and_zoneable_type", using: :btree

  create_table "spree_zones", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        default: false
    t.integer  "zone_members_count", default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "kind"
  end

  add_index "spree_zones", ["default_tax"], name: "index_spree_zones_on_default_tax", using: :btree
  add_index "spree_zones", ["kind"], name: "index_spree_zones_on_kind", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "slug"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "editable"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
  end

  create_table "store_notices", force: :cascade do |t|
    t.text     "content"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_managers", force: :cascade do |t|
    t.string   "tag_manager_id"
    t.boolean  "active"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "search_count", default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "tags_products", force: :cascade do |t|
    t.integer  "spree_product_id"
    t.integer  "tag_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "tags_products", ["spree_product_id"], name: "index_tags_products_on_spree_product_id", using: :btree
  add_index "tags_products", ["tag_id"], name: "index_tags_products_on_tag_id", using: :btree

  create_table "technical_documents", force: :cascade do |t|
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.string   "document_type"
    t.datetime "document_updated_at"
    t.integer  "spree_product_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "technical_documents", ["spree_product_id"], name: "index_technical_documents_on_spree_product_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",              null: false
    t.integer  "item_id",      limit: 8, null: false
    t.string   "event",                  null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "line_item_id"
    t.text     "line_items"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "virtual_supports", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.text     "url"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.text     "subtitle"
    t.text     "subdescription"
  end

  create_table "visits", force: :cascade do |t|
    t.string   "visit_token"
    t.string   "visitor_token"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree
  add_index "visits", ["visit_token"], name: "index_visits_on_visit_token", unique: true, using: :btree

  add_foreign_key "comparable_attributes", "spree_taxons"
  add_foreign_key "comparator_items", "comparators"
  add_foreign_key "comparator_items", "spree_variants"
  add_foreign_key "comparators", "spree_users"
  add_foreign_key "comunas", "provinces"
  add_foreign_key "product_comparable_attributes", "comparable_attributes"
  add_foreign_key "product_comparable_attributes", "spree_products"
  add_foreign_key "promotional_banners", "spree_taxons"
  add_foreign_key "provinces", "spree_states"
  add_foreign_key "quotations", "spree_addresses"
  add_foreign_key "quotations", "spree_products"
  add_foreign_key "quotations", "spree_users"
  add_foreign_key "specific_attributes", "spree_products"
  add_foreign_key "spree_addresses", "comunas"
  add_foreign_key "spree_orders", "visits"
  add_foreign_key "tags_products", "spree_products"
  add_foreign_key "tags_products", "tags"
  add_foreign_key "technical_documents", "spree_products"
end
