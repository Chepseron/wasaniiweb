# == Schema Information
#
# Table name: collection_albums
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  visible            :boolean
#  parent_id          :integer
#  parent_type        :string
#  collection_type_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cover_pic_uid      :string
#  album_date         :date
#  slug               :string
#  aasm_state         :string
#
# Indexes
#
#  index_collection_albums_on_slug  (slug)
#

class CollectionAlbum < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title description)

  belongs_to :parent, polymorphic: true
  validates_presence_of :title, :description
  has_many :collection_entities, :dependent => :destroy
  has_many :books, through: :collection_entities, source: :entity, source_type: "Book"
  has_many :photo_arts, through: :collection_entities, source: :entity, source_type: "PhotoArt"
  has_many :productions, through: :collection_entities, source: :entity, source_type: "Production"
  has_many :songs, through: :collection_entities, source: :entity, source_type: "Song"
  has_many :impressions, as: :entity, dependent: :destroy
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_and_belongs_to_many :life_events

  attr_reader :book_id_tags, :song_id_tags, :photo_art_id_tags, :production_id_tags

  friendly_id :title, use: [:slugged, :history]
  dragonfly_accessor :cover_pic

  default_scope -> {order('created_at desc')}
  scope :published, lambda{where(:aasm_state => 'published')}
  scope :verified, lambda { where(:parent => true) }

  def date
    album_date
  end

  def photo_art_id_tags=(val)
    self.photo_art_ids = val.split(",")
  end

  def song_id_tags=(val)
    self.song_ids = val.split(",")
  end

  def production_id_tags=(val)
    self.production_ids = val.split(",")
  end

  def book_id_tags=(val)
    self.book_ids = val.split(",")
  end

  def country
    ISO3166::Country.find_country_by_alpha2(parent.country_of_birth).name
  end

  def self.trending
    return Impression.where(entity_type: 'CollectionAlbum').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|collection_album_id,count| CollectionAlbum.find_by_id(collection_album_id).parent}.compact
  end

  def self.viewable
    all.collect do |collection_album|
      collection_album if collection_album.aasm_state == 'published' || collection_album.parent.verified
    end.compact
  end

end
