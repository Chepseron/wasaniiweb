# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  type_id     :integer
#  description :text
#  charges     :string
#  venue_id    :integer
#  date        :date
#  aasm_state  :string
#  parent_id   :integer
#  parent_type :string
#  image_uid   :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  time        :string
#  featured    :boolean
#  enddate     :date
#  url         :string
#
# Indexes
#
#  index_events_on_slug  (slug)
#

class Event < ApplicationRecord
  extend FriendlyId
  include EntityState
  include PgSearch

  multisearchable against: %i(name description)

  #before_validation :event_venue
  validates_presence_of :name, :description, :charges, :date  

  belongs_to :parent, polymorphic: :true
  belongs_to :type, class_name: 'Industry'
  belongs_to :venue, class_name: 'Business'
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_many :impressions, as: :entity, dependent: :destroy

  has_and_belongs_to_many :blog_links, class_name: 'Blog', join_table: :blogs_events
  has_and_belongs_to_many :news_stories_links, class_name: 'NewsStory', join_table: :events_news_stories
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :awards

  friendly_id :name, use: [:slugged, :history]
  dragonfly_accessor :image

  attr_reader :artist_id_tags, :award_id_tags

  default_scope -> {order('date desc')}
  scope :featured, -> { where(featured: true) }
  scope :current, -> {where('date > ?', (Date.today - 3))}  
  scope :published, lambda{where(:aasm_state => 'published')}
  scope :verified, lambda { where(:parent => true) }
  
  validate :end_date_and_start_date
  

  def country
    if parent.is_a?(Artist)
      return ISO3166::Country.find_country_by_alpha2(parent.country_of_birth).name
    else
      return ISO3166::Country.find_country_by_alpha2(parent.country).name
    end
  end

  def self.trending
    return Impression.where(entity_type: 'Event').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|event_id,count| Event.find_by_id(event_id)}.compact
  end

  def artist_id_tags=(val)
    self.artist_ids = val.split(",")
  end

  def award_id_tags=(val)
    self.award_ids = val.split(",")
  end

  def event_venue_name=(val)
      if(Business.find_by_name(val).try(:id).nil?)
        biz = Business.create(:name => val, :country => 'KE', :business_category => BusinessCategory.find(16),)
        self[:venue_id] = biz.id
      else
         self[:venue_id] = Business.find_by_name(val).try(:id)
      end     
  end

  def event_venue_name
    Business.find(venue_id).name if venue_id
  end

  def self.viewable
    all.collect do |event|
      event if event.aasm_state == 'published' || event.parent.verified
    end.compact
  end

  private
    def end_date_and_start_date
      start_date = date.to_datetime.strftime('%Q')
      end_date = enddate.to_datetime.strftime('%Q')
      if(end_date < start_date)
        errors.add(:end_date, "should come after start date")
      end
    end
    def event_venue
      if(Business.find_by_name(name).try(:id).nil?)
        biz = Business.create(:name => name)
        self[:venue_id] = biz.id
      else
         self[:venue_id] = Business.find_by_name(name).try(:id)
      end  
      #errors.add(:end_date, "wrong bro")   
    end
end