# == Schema Information
#
# Table name: productions
#
#  id                     :integer          not null, primary key
#  cover_picture_uid      :string
#  production_category_id :integer
#  title                  :string
#  language_id            :integer
#  running_time           :integer
#  release_date           :date
#  synopsis               :text
#  director_id            :integer
#  production_company_id  :integer
#  trailer_url            :string
#  parent_id              :integer
#  parent_type            :string
#  aasm_state             :string
#  slug                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_productions_on_slug  (slug)
#

class Production < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title synopsis)

  before_save :get_youtube_image

  belongs_to :parent, polymorphic: :true
  belongs_to :production_category
  belongs_to :language

  has_and_belongs_to_many :directors, class_name: 'Artist', join_table: :directors_productions
  has_and_belongs_to_many :production_companies, class_name: 'Business'
  has_and_belongs_to_many :cast, class_name: 'Artist', join_table: :artists_productions

  has_many :collection_entities, as: :entity, :dependent => :destroy
  has_many :awards, as: :recipient
  has_many :impressions, as: :entity, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates_presence_of :release_date, :synopsis
  validate :trailer_valid?, unless: 'trailer_url.blank?'

  default_scope -> {order('created_at desc')}
  scope :published, lambda{where(:aasm_state => 'published')}
  scope :verified, lambda { where(:parent => true) }


  friendly_id :title, use: [:slugged, :history]
  dragonfly_accessor :cover_picture

  attr_reader :production_company_id_tags, :director_id_tags, :cast_id_tags

  def country
    ISO3166::Country.find_country_by_alpha2(self.parent.country_of_birth).name if parent_id.present?
  end

  def date
    release_date
  end

  def director_name=(val)
    self[:director_id] = Artist.find_by_profile_name(val).id unless Artist.find_by_profile_name(val).nil?
  end

  def director_name
    Artist.find(director_id).profile_name if director_id
  end

  def production_company_name=(val)
    self[:production_company_id] = Business.find_by_name(val).id unless Business.find_by_name(val).nil?
  end

  def production_company_name
    Business.find(production_company_id).name if production_company_id
  end

  def language_name=(val)
    language = Language.find_by_name(val.titlecase) unless Language.find_by_name(val.titlecase).nil?
    if language
      self[:language_id] = language.id
    else
      self[:language_id] = Language.create!(name: val.titlecase).id unless val.blank?
    end
  end

  def language_name
    Language.find(language_id).name if language_id
  end

  def trailer_valid?
    begin
      video = VideoInfo.new(trailer_url)
      return errors.add(:trailer_url, 'not available') unless video.available?
    rescue
      return errors.add(:trailer_url, 'URL is not valid')
    end
  end

  def get_youtube_image
    begin
      if cover_picture.nil? && !trailer_url.blank? || !trailer_url.blank? && trailer_url_changed?
        video = VideoInfo.new(trailer_url)
        self.cover_picture_url = video.thumbnail_large
      end
    rescue
      return errors.add(:trailer_url, 'Image is not valid')
    end
  end

  def production_company_id_tags=(val)
    self.production_company_ids = val.split(",")
  end

  def director_id_tags=(val)
    self.director_ids = val.split(",")
  end

  def cast_id_tags=(val)
    self.cast_ids = val.split(",")
  end

  def self.trending
    return Impression.where(entity_type: 'Production').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|production_id,count| Production.find_by_id(production_id).parent}.compact
  end

  def self.viewable
    all.collect do |production|
      production if production.aasm_state == 'published' || production.parent.verified
    end.compact
  end

end
