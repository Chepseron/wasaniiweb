# == Schema Information
#
# Table name: life_events
#
#  id                     :integer          not null, primary key
#  date                   :date
#  title                  :string
#  life_event_category_id :integer
#  description            :text
#  parent_id              :integer
#  parent_type            :string
#  aasm_state             :string
#  slug                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  duration               :string
#  image_uid              :string
#
# Indexes
#
#  index_life_events_on_slug  (slug)
#

class LifeEvent < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title description)

  validates_presence_of :title, :description, :date

  belongs_to :parent, polymorphic: :true
  belongs_to :life_event_category
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :books
  has_and_belongs_to_many :productions
  has_and_belongs_to_many :photo_arts
  has_and_belongs_to_many :collection_albums
  has_and_belongs_to_many :awards

  has_many :impressions, as: :entity, dependent: :destroy

  default_scope -> {order('date desc')}

  dragonfly_accessor :image
  friendly_id :title, use: [:slugged, :history]

  attr_reader :book_id_tags, :production_id_tags, :song_id_tags, :photo_art_id_tags, :collection_album_id_tags, :award_id_tags

  def book_id_tags=(val)
    self.book_ids = val.split(",")
  end

  def production_id_tags=(val)
    self.production_ids = val.split(",")
  end

  def collection_album_id_tags=(val)
    self.collection_album_ids = val.split(",")
  end

  def song_id_tags=(val)
    self.song_ids = val.split(",")
  end

  def photo_art_id_tags=(val)
    self.photo_art_ids = val.split(",")
  end

  def award_id_tags=(val)
    self.award_ids = val.split(",")
  end

  def entities
    books + songs + productions + photo_arts + collection_albums + awards
  end

end
