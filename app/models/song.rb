# == Schema Information
#
# Table name: songs
#
#  id                    :integer          not null, primary key
#  title                 :string
#  description           :text
#  lyrics                :text
#  audio_url             :string
#  audio_category_id     :integer
#  video_url             :string
#  image_uid             :string
#  release_date          :date
#  parent_id             :integer
#  parent_type           :string
#  aasm_state            :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  production_company_id :integer
#
# Indexes
#
#  index_songs_on_slug  (slug)
#

class Song < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title description)

  before_save :get_youtube_image

  validates_presence_of :title, :description, :release_date
  validate :video_valid?, unless: 'video_url.blank?'

  validate :valid_production_company

  belongs_to :parent, polymorphic: :true
  has_many :collection_entities, as: :entity, :dependent => :destroy
  has_many :awards, as: :recipient

  has_many :impressions, as: :entity, dependent: :destroy

  has_and_belongs_to_many :life_events
  has_and_belongs_to_many :featured_artists, class_name: 'Artist', join_table: :artists_songs
  belongs_to :production_company, class_name: 'Business', optional: true

  friendly_id :title, use: [:slugged, :history]
  dragonfly_accessor :image

  default_scope -> {order('created_at desc')}
  scope :published, lambda{where(:aasm_state => 'published')}
  scope :verified, lambda { where(:parent => true) }

  attr_reader :featured_artists_id_tags

  def valid_production_company
    if production_company_id == -1
      errors.add(:production_company_name, 'must be an existing company')
      self[:production_company_id] = nil
    end
  end

  def production_company_name=(val)
    begin
      self[:production_company_id] = Business.find_by_name(val).id unless val.blank?
    rescue
      self[:production_company_id] = -1
    end
  end

  def production_company_name
    Business.find(production_company_id).name if production_company_id
  end

  def featured_artists_id_tags=(val)
    self.featured_artist_ids = val.split(",")
  end

  def country
    ISO3166::Country.find_country_by_alpha2(parent.country_of_birth).name
  end

  def parent_verified
    self.parent.verified
  end

  def date
    release_date
  end

  def video_valid?
    begin
      video = VideoInfo.new(video_url)
      return errors.add(:video_url, 'not available') unless video.available?
    rescue
      return errors.add(:video_url, 'URL is not valid')
    end
  end

  def get_youtube_image
    begin
      if image.nil? && !video_url.blank? || !video_url.blank? && video_url_changed?
        video = VideoInfo.new(video_url)
        self.image_url = video.thumbnail_large
      end
    rescue
      return errors.add(:video_url, 'Image is not valid')
    end
  end

  def self.trending
    return Impression.where(entity_type: 'Song').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|song_id,count| Song.find_by_id(song_id)}.compact
  end

  def self.viewable
    all.collect do |song|
      song if song.aasm_state == 'published' || song.parent.verified
    end.compact
  end

end
