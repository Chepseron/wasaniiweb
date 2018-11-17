# == Schema Information
#
# Table name: businesses
#
#  id                   :integer          not null, primary key
#  name                 :string
#  country              :string
#  logo_uid             :string
#  company_info         :text
#  latitude             :float
#  longitude            :float
#  business_category_id :integer
#  parent_id            :integer
#  parent_type          :string
#  verified             :boolean          default(FALSE)
#  slug                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  physical_location    :text
#  phone_number         :string
#  email                :string
#  working_hours        :string
#  featured             :boolean
#  banned               :boolean
#
# Indexes
#
#  index_businesses_on_parent_id    (parent_id)
#  index_businesses_on_parent_type  (parent_type)
#  index_businesses_on_slug         (slug) UNIQUE
#

class Business < ApplicationRecord
  extend FriendlyId
  include PgSearch

  multisearchable :against => [:name, :company_info]

  belongs_to :parent, polymorphic: true, optional: true
  belongs_to :business_category, optional: true
  has_many :artists, as: :parent, :dependent => :destroy
  has_many :news_stories, as: :parent, :dependent => :destroy
  has_many :events, as: :parent, :dependent => :destroy
  has_many :blogs, as: :parent, :dependent => :destroy
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_many :hosted_events, class_name: Event, source: :venue, foreign_key: :venue_id, :dependent => :destroy
  has_many :links, as: :parent, :dependent => :destroy
  has_and_belongs_to_many :industries
  has_many :published_books, foreign_key: :publishing_company_id, :dependent => :destroy
  has_many :awards, :dependent => :destroy
  has_many :productions, as: :parent, :dependent => :destroy


  has_and_belongs_to_many :blog_links, class_name: 'Blog', join_table: :blogs_businesses
  has_and_belongs_to_many :news_stories_links, class_name: 'NewsStory', join_table: :businesses_news_stories

  has_and_belongs_to_many :production_works, class_name: 'Production'

  has_many :page_admins, as: :page, :dependent => :destroy
  has_many :managing_users, through: :page_admins, source: :user
  has_many :business_fans, :dependent => :destroy

  has_many :impressions, as: :entity, dependent: :destroy
  has_many :suggested_updates, as: :parent, :dependent => :destroy

  validates_presence_of  :name, if: :has_no_parent?  
  validates_presence_of :name, :country, :latitude, :longitude, :business_category, if: :created_by_admin?
  validates_presence_of :name, :country, :latitude, :longitude, :company_info, :business_category, if: :created_by_user?
  validates_presence_of :country, :business_category
  validate :has_industry?, if: :created_by_user?
  validates_uniqueness_of :name

  validates_format_of :email, :with => /@/, message: 'Please enter a valid email address', unless: :email_blank?

  friendly_id :name, use: [:slugged, :history]

  dragonfly_accessor :logo

  default_scope { order(:name) }
  scope :verified, -> { where(verified: true) }
  scope :featured, -> { where(featured: true) }
  scope :viewable, -> { where(banned: [false, nil])}

  def works
    artists.collect{|artist| artist.works}.flatten + productions
  end

  def viewable_works
    artists.collect{|artist| artist.viewable_works}.flatten + productions.viewable
  end

  private

  def email_blank?
    email.blank?
  end

  def has_no_parent?
    self.parent.nil?
  end

  def created_by_admin?
    self.parent.is_a? Admin
  end

  def created_by_user?
    self.parent.is_a? User
  end

  def has_industry?
    return errors.add(:industries, 'must select at least one') if industries.empty?
  end

end
