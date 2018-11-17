# == Schema Information
#
# Table name: awards
#
#  id          :integer          not null, primary key
#  name        :string
#  business_id :integer
#  details     :text
#  image_uid   :string
#  country     :string
#  start_year  :integer
#  industry_id :integer
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aasm_state  :string
#
# Indexes
#
#  index_awards_on_slug  (slug) UNIQUE
#

class Award < ApplicationRecord
  extend FriendlyId
  include PgSearch
  include EntityState

  multisearchable against: %i(name details)

  friendly_id :name, use: [:slugged, :history]

  belongs_to :business
  belongs_to :industry

  has_many :award_categories, :dependent => :destroy
  has_many :nominees, through: :award_categories, :dependent => :destroy
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_and_belongs_to_many :blogs
  has_and_belongs_to_many :events
  has_and_belongs_to_many :news_stories

  dragonfly_accessor :image

  validates_presence_of :name, :details, :industry_id

  default_scope -> {order('created_at desc')}

  scope :viewable, -> { where(aasm_state: [:approved,:approved_with_changes])}
  
end
