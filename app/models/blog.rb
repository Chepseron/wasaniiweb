# == Schema Information
#
# Table name: blogs
#
#  id          :integer          not null, primary key
#  title       :string
#  content     :text
#  date        :date
#  parent_id   :integer
#  parent_type :string
#  aasm_state  :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image_uid   :string
#
# Indexes
#
#  index_blogs_on_slug  (slug)
#

class Blog < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(title content)

  validates_presence_of :title, :content, :date

  belongs_to :parent, polymorphic: :true
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :businesses
  has_and_belongs_to_many :events
  has_many :impressions, as: :entity, dependent: :destroy
  has_and_belongs_to_many :awards

  friendly_id :title, use: [:slugged, :history]
  dragonfly_accessor :image

  default_scope -> {order('date desc')}

  attr_reader :artist_id_tags, :business_id_tags, :event_id_tags, :award_id_tags

  def country
    if parent.is_a?(Artist)
      return ISO3166::Country.find_country_by_alpha2(parent.country_of_birth).name
    else
      return ISO3166::Country.find_country_by_alpha2(parent.country).name
    end
  end

  def artist_id_tags=(val)
    self.artist_ids = val.split(",")
  end

  def award_id_tags=(val)
    self.award_ids = val.split(",")
  end

  def business_id_tags=(val)
    self.business_ids = val.split(",")
  end

  def event_id_tags=(val)
    self.event_ids = val.split(",")
  end

  def self.trending
    return Impression.where(entity_type: 'Blog').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|blog_id,count| Blog.find_by_id(blog_id)}.compact
  end

  def self.viewable
    all.collect do |blog|
      blog if blog.aasm_state == 'published' || blog.parent.verified
    end.compact
  end
end
