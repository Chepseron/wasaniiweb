# == Schema Information
#
# Table name: photo_arts
#
#  id          :integer          not null, primary key
#  title       :string
#  date        :date
#  description :text
#  image_uid   :string
#  parent_id   :integer
#  parent_type :string
#  aasm_state  :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_photo_arts_on_slug  (slug)
#

class PhotoArt < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title description)

	belongs_to :parent, polymorphic: :true
  has_and_belongs_to_many :life_events
  has_many :awards, as: :recipient
  has_many :impressions, as: :entity, dependent: :destroy
  has_many :collection_entities, as: :entity, :dependent => :destroy
  has_many :gallery_photos, as: :parent, :dependent => :destroy

  validates_presence_of :title, :description, :date

  default_scope -> {order('created_at desc')}
  scope :published, lambda{where(:aasm_state => 'published')}
  scope :verified, lambda { where(:parent => true) }

  dragonfly_accessor :image

  friendly_id :title, use: [:slugged, :history]
  scope :viewable, -> { where(aasm_state: [:approved,:approved_with_changes])}

  def country
    ISO3166::Country.find_country_by_alpha2(parent.country_of_birth).name
  end

  def self.trending
    return Impression.where(entity_type: 'PhotoArt').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|photo_art_id,count| PhotoArt.find_by_id(photo_art_id).parent}.compact
  end

  def self.viewable
    all.collect do |photo_art|
      photo_art if photo_art.aasm_state == 'published' || photo_art.parent.verified
    end.compact
  end

end
