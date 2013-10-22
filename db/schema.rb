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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131022002400) do

  create_table "acts_as_xapian_jobs", :force => true do |t|
    t.string  "model",    :null => false
    t.integer "model_id", :null => false
    t.string  "action",   :null => false
  end

  add_index "acts_as_xapian_jobs", ["model", "model_id"], :name => "index_acts_as_xapian_jobs_on_model_and_model_id", :unique => true

  create_table "bill_events", :force => true do |t|
    t.integer  "bill_id"
    t.string   "name"
    t.date     "date"
    t.string   "source_type"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", :force => true do |t|
    t.text    "url"
    t.string  "bill_no",                                 :limit => 8
    t.integer "formerly_part_of_id"
    t.integer "member_in_charge_id"
    t.integer "referred_to_committee_id"
    t.string  "type",                                    :limit => 15,  :null => false
    t.string  "bill_name",                               :limit => 155, :null => false
    t.string  "parliament_url",                                         :null => false
    t.string  "parliament_id",                                          :null => false
    t.date    "introduction"
    t.date    "first_reading"
    t.boolean "first_reading_negatived",                                :null => false
    t.date    "first_reading_discharged"
    t.date    "submissions_due"
    t.date    "sc_reports_interim_report"
    t.date    "sc_reports"
    t.date    "sc_reports_discharged"
    t.date    "consideration_of_report"
    t.date    "consideration_of_report_discharged"
    t.date    "second_reading"
    t.boolean "second_reading_negatived",                               :null => false
    t.date    "second_reading_discharged"
    t.date    "committee_of_the_whole_house"
    t.date    "committal_discharged"
    t.date    "third_reading"
    t.date    "royal_assent"
    t.date    "withdrawn"
    t.string  "former_name",                             :limit => 155
    t.string  "act_name",                                :limit => 155
    t.text    "description"
    t.date    "earliest_date",                                          :null => false
    t.date    "second_reading_withdrawn"
    t.string  "plain_bill_name"
    t.string  "plain_former_name"
    t.date    "committee_of_the_whole_house_discharged"
    t.string  "formerly_part_of_text"
  end

  add_index "bills", ["bill_name"], :name => "index_bills_on_bill_name"
  add_index "bills", ["former_name"], :name => "index_bills_on_former_name"
  add_index "bills", ["formerly_part_of_id"], :name => "index_bills_on_formerly_part_of_id"
  add_index "bills", ["member_in_charge_id"], :name => "index_bills_on_member_in_charge_id"
  add_index "bills", ["plain_bill_name"], :name => "index_bills_on_plain_bill_name"
  add_index "bills", ["plain_former_name"], :name => "index_bills_on_plain_former_name"
  add_index "bills", ["referred_to_committee_id"], :name => "index_bills_on_referred_to_committee_id"

  create_table "committee_chairs", :force => true do |t|
    t.integer "chairs_id",               :null => false
    t.string  "role",      :limit => 82, :null => false
  end

  add_index "committee_chairs", ["chairs_id"], :name => "index_committee_chairs_on_chairs_id"

  create_table "committees", :force => true do |t|
    t.integer "clerk_category_id"
    t.string  "committee_type",    :limit => 19, :null => false
    t.string  "committee_name",    :limit => 46, :null => false
    t.text    "url",                             :null => false
    t.text    "description"
    t.boolean "former",                          :null => false
  end

  create_table "contributions", :force => true do |t|
    t.integer "spoken_in_id", :null => false
    t.integer "spoken_by_id"
    t.string  "type",         :null => false
    t.string  "speaker"
    t.string  "on_behalf_of"
    t.time    "time"
    t.integer "page"
    t.integer "vote_id"
    t.text    "text",         :null => false
    t.date    "date"
    t.integer "date_int"
  end

  add_index "contributions", ["date"], :name => "index_contributions_on_date"
  add_index "contributions", ["spoken_by_id"], :name => "index_contributions_on_spoken_by_id"
  add_index "contributions", ["spoken_in_id"], :name => "index_contributions_on_spoken_in_id"
  add_index "contributions", ["text"], :name => "speech_index"
  add_index "contributions", ["vote_id"], :name => "index_contributions_on_vote_id"

  create_table "debate_topics", :force => true do |t|
    t.integer "debate_id",                :null => false
    t.string  "topic_type", :limit => 15
    t.integer "topic_id",                 :null => false
  end

  add_index "debate_topics", ["debate_id"], :name => "index_debate_topics_on_debate_id"

  create_table "debates", :force => true do |t|
    t.date    "date",                            :null => false
    t.integer "debate_index",                    :null => false
    t.string  "publication_status", :limit => 1, :null => false
    t.string  "source_url"
    t.string  "type",                            :null => false
    t.integer "hansard_volume"
    t.integer "start_page"
    t.string  "name",                            :null => false
    t.string  "css_class",                       :null => false
    t.integer "debate_id"
    t.string  "about_type"
    t.integer "about_id"
    t.integer "about_index"
    t.string  "answer_from_type"
    t.integer "answer_from_id"
    t.integer "oral_answer_no"
    t.integer "re_oral_answer_no"
    t.string  "url_slug"
    t.string  "url_category"
  end

  add_index "debates", ["about_id"], :name => "index_debates_on_about_id"
  add_index "debates", ["about_type", "about_id", "publication_status"], :name => "debate_on_type_status_id"
  add_index "debates", ["date"], :name => "index_debates_on_date"
  add_index "debates", ["debate_id"], :name => "index_debates_on_debate_id"
  add_index "debates", ["url_category"], :name => "index_debates_on_url_category"
  add_index "debates", ["url_slug"], :name => "index_debates_on_url_slug"

  create_table "donations", :force => true do |t|
    t.string   "party_name"
    t.integer  "party_id"
    t.string   "donor_name"
    t.integer  "organisation_id"
    t.string   "donor_address"
    t.integer  "amount"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donations", ["organisation_id"], :name => "index_donations_on_organisation_id"
  add_index "donations", ["party_id"], :name => "index_donations_on_party_id"

  create_table "geonames", :force => true do |t|
    t.integer "geonameid"
    t.string  "name"
    t.string  "first_word_in_name"
    t.string  "asciiname"
    t.text    "alternatenames"
    t.decimal "latitude",           :precision => 10, :scale => 7
    t.decimal "longitude",          :precision => 10, :scale => 7
    t.string  "feature_class"
    t.string  "feature_code"
    t.string  "country_code"
    t.string  "cc2"
    t.string  "admin1_code"
    t.string  "admin2_code"
    t.string  "admin3_code"
    t.string  "admin4_code"
    t.integer "population"
    t.integer "elevation"
    t.integer "gtopo30"
    t.string  "timezone"
    t.date    "modification_date"
    t.string  "slug"
    t.integer "count_of_mentions"
  end

  add_index "geonames", ["first_word_in_name"], :name => "index_geonames_on_first_word_in_name"

  create_table "members", :force => true do |t|
    t.integer  "person_id"
    t.string   "electorate"
    t.integer  "party_id"
    t.date     "from_date"
    t.date     "to_date"
    t.string   "from_what"
    t.string   "list_member_vacancy_url"
    t.string   "members_sworn_url"
    t.string   "maiden_statement_url"
    t.string   "to_what"
    t.string   "membership_change_url"
    t.string   "resignation_url"
    t.string   "valedictory_statement_url"
    t.integer  "replaced_by_id"
    t.integer  "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parliament_id"
    t.string   "image"
  end

  add_index "members", ["parliament_id"], :name => "index_members_on_parliament_id"
  add_index "members", ["person_id"], :name => "index_members_on_person_id"

  create_table "ministers", :force => true do |t|
    t.integer "responsible_for_id",               :null => false
    t.string  "title",              :limit => 82, :null => false
  end

  add_index "ministers", ["responsible_for_id"], :name => "index_ministers_on_responsible_for_id"

  create_table "mps", :force => true do |t|
    t.string  "elected",         :limit => 4,  :null => false
    t.boolean "former",                        :null => false
    t.string  "id_name",         :limit => 46, :null => false
    t.string  "last",            :limit => 20, :null => false
    t.string  "first",           :limit => 25, :null => false
    t.string  "title",           :limit => 13
    t.string  "electorate",      :limit => 25
    t.integer "member_of_id"
    t.string  "img",             :limit => 25, :null => false
    t.string  "alt",             :limit => 20
    t.string  "honour",          :limit => 3
    t.string  "wikipedia_url"
    t.string  "parliament_url"
    t.string  "own_website_url"
    t.string  "party_bio_url"
    t.string  "image"
    t.string  "alt_image"
    t.string  "alt_last"
  end

  add_index "mps", ["id_name"], :name => "index_mps_on_id_name"
  add_index "mps", ["member_of_id"], :name => "index_mps_on_member_of_id"

  create_table "nzl_events", :force => true do |t|
    t.string   "title"
    t.string   "about_type"
    t.integer  "about_id"
    t.string   "status"
    t.string   "nzl_id"
    t.string   "version_stage"
    t.date     "version_date"
    t.string   "version_committee"
    t.integer  "committee_id"
    t.string   "information_type"
    t.string   "legislation_type"
    t.integer  "year"
    t.string   "no"
    t.date     "current_as_at_date"
    t.string   "link"
    t.datetime "publication_date"
  end

  add_index "nzl_events", ["about_id"], :name => "index_nzl_events_on_about_id"
  add_index "nzl_events", ["about_type"], :name => "index_nzl_events_on_about_type"
  add_index "nzl_events", ["committee_id"], :name => "index_nzl_events_on_committee_id"

  create_table "order_paper_alerts", :force => true do |t|
    t.date     "order_paper_date"
    t.string   "name"
    t.date     "alert_date"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_paper_alerts", ["alert_date"], :name => "index_order_paper_alerts_on_alert_date"
  add_index "order_paper_alerts", ["name"], :name => "index_order_paper_alerts_on_name"

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wikipedia_url"
    t.integer  "count_of_mentions"
    t.string   "alternate_names"
    t.string   "sourcewatch_url"
  end

  create_table "parliament_parties", :force => true do |t|
    t.integer "parliament_id"
    t.integer "party_id"
    t.text    "parliament_description"
    t.text    "in_parliament_text"
    t.text    "parliament_agreements_text"
    t.string  "agreements_file"
    t.string  "parliament_url"
    t.string  "wikipedia_url"
    t.integer "party_votes_count"
    t.integer "bill_final_reading_party_votes_count"
  end

  add_index "parliament_parties", ["parliament_id"], :name => "index_parliament_parties_on_parliament_id"
  add_index "parliament_parties", ["party_id"], :name => "index_parliament_parties_on_party_id"

  create_table "parliaments", :force => true do |t|
    t.string  "ordinal"
    t.date    "commission_opening_date"
    t.integer "commission_opening_debate_id"
    t.date    "dissolution_date"
    t.string  "wikipedia_url"
    t.integer "party_votes_count"
    t.integer "bill_final_reading_party_votes_count"
  end

  create_table "parties", :force => true do |t|
    t.string "short",                      :null => false
    t.string "name"
    t.string "vote_name"
    t.date   "registered"
    t.string "abbreviation"
    t.string "url"
    t.string "colour",        :limit => 6
    t.string "logo"
    t.string "wikipedia_url"
  end

  add_index "parties", ["vote_name"], :name => "index_parties_on_vote_name"

  create_table "pecuniary_categories", :force => true do |t|
    t.boolean "snapshot",                :null => false
    t.date    "from_date",               :null => false
    t.date    "to_date",                 :null => false
    t.string  "name",      :limit => 72, :null => false
  end

  create_table "pecuniary_interests", :force => true do |t|
    t.integer "pecuniary_category_id", :null => false
    t.integer "mp_id",                 :null => false
    t.text    "item",                  :null => false
  end

  add_index "pecuniary_interests", ["mp_id"], :name => "index_pecuniary_interests_on_mp_id"
  add_index "pecuniary_interests", ["pecuniary_category_id"], :name => "index_pecuniary_interests_on_pecuniary_category_id"

  create_table "persisted_files", :force => true do |t|
    t.date    "debate_date"
    t.string  "publication_status", :limit => 1
    t.boolean "oral_answer"
    t.boolean "downloaded"
    t.date    "download_date"
    t.boolean "is_persisted"
    t.date    "persisted_date"
    t.string  "file_name"
    t.string  "parliament_name"
    t.string  "parliament_url"
    t.integer "index_on_date"
    t.string  "name"
    t.string  "written_status",     :limit => 10
  end

  add_index "persisted_files", ["name"], :name => "index_persisted_files_on_name"
  add_index "persisted_files", ["publication_status"], :name => "index_persisted_files_on_publication_status"

  create_table "portfolios", :force => true do |t|
    t.integer "beehive_id"
    t.string  "portfolio_name",      :limit => 82, :null => false
    t.text    "url"
    t.string  "dpmc_id",             :limit => 42
    t.boolean "dpmc_responsibility"
  end

  create_table "roles", :force => true do |t|
    t.integer "mp_id",      :null => false
    t.date    "start_date"
    t.date    "end_date"
    t.string  "title"
  end

  create_table "sitting_days", :force => true do |t|
    t.date    "date"
    t.boolean "has_oral_answers"
    t.boolean "has_advance"
    t.boolean "has_final"
  end

  create_table "submission_dates", :force => true do |t|
    t.string  "parliament_url", :null => false
    t.integer "committee_id"
    t.integer "bill_id",        :null => false
    t.date    "date"
    t.string  "title",          :null => false
    t.string  "details",        :null => false
  end

  add_index "submission_dates", ["bill_id"], :name => "index_submission_dates_on_bill_id"
  add_index "submission_dates", ["committee_id"], :name => "index_submission_dates_on_committee_id"

  create_table "submissions", :force => true do |t|
    t.string  "submitter_name"
    t.string  "submitter_url"
    t.string  "business_item_name"
    t.integer "committee_id"
    t.date    "date"
    t.string  "evidence_url"
    t.string  "business_item_type"
    t.integer "business_item_id"
    t.boolean "is_from_organisation"
    t.string  "submitter_type"
    t.integer "submitter_id"
  end

  create_table "trackings", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.integer  "user_id"
    t.boolean  "tracking_on"
    t.boolean  "email_alert"
    t.boolean  "include_in_feed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "type"
    t.string   "login"
    t.string   "hashed_password"
    t.string   "email"
    t.string   "salt"
    t.string   "blog_url"
    t.string   "site_url"
    t.boolean  "email_confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vote_casts", :force => true do |t|
    t.integer "vote_id",                  :null => false
    t.string  "cast",       :limit => 12, :null => false
    t.integer "cast_count",               :null => false
    t.string  "vote_label",               :null => false
    t.integer "mp_id"
    t.integer "party_id"
    t.boolean "present"
    t.boolean "teller"
  end

  add_index "vote_casts", ["mp_id"], :name => "index_vote_casts_on_mp_id"
  add_index "vote_casts", ["party_id"], :name => "index_vote_casts_on_party_id"
  add_index "vote_casts", ["vote_id"], :name => "index_vote_casts_on_vote_id"

  create_table "votes", :force => true do |t|
    t.string  "type",              :limit => 12
    t.text    "vote_question"
    t.text    "vote_result"
    t.integer "ayes_tally"
    t.integer "noes_tally"
    t.integer "abstentions_tally"
  end

  create_table "written_question_links", :force => true do |t|
    t.integer "from_id"
    t.integer "to_id"
    t.string  "link_type"
  end

  create_table "written_questions", :force => true do |t|
    t.text    "question"
    t.text    "answer"
    t.string  "status"
    t.integer "question_number"
    t.integer "question_year"
    t.integer "asker_id"
    t.integer "portfolio_id"
    t.integer "respondent_id"
    t.date    "date_asked"
    t.integer "days_late"
    t.string  "subject"
    t.string  "portfolio_name"
  end

  add_index "written_questions", ["status"], :name => "index_written_questions_on_status"

end
