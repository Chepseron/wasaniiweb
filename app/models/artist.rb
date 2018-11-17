# == Schema Information
#
# Table name: artists
#
#  id                   :integer          not null, primary key
#  profile_name         :string
#  name                 :string
#  contact_phone_number :string
#  contact_email        :string
#  gender               :string
#  birthday             :date
#  country_of_birth     :string
#  profile_pic_uid      :string
#  introduction         :text
#  parent_id            :integer
#  parent_type          :string
#  verified             :boolean          default(FALSE)
#  aasm_state           :string
#  slug                 :string
#  height               :string
#  weight               :string
#  bust                 :string
#  hips                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  featured             :boolean
#
# Indexes
#
#  index_artists_on_parent_id    (parent_id)
#  index_artists_on_parent_type  (parent_type)
#  index_artists_on_slug         (slug) UNIQUE
#

class Artist < ApplicationRecord
  extend FriendlyId
  include AASM
  include PgSearch

  multisearchable :against => [:name, :profile_name, :introduction]

  friendly_id :profile_name, use: [:slugged, :history]

  belongs_to :parent, polymorphic: true

  dragonfly_accessor :profile_pic

  has_many :events, as: :parent, :dependent => :destroy
  has_many :life_events, as: :parent, :dependent => :destroy
  has_many :news_stories, as: :parent, :dependent => :destroy
  has_many :blogs, as: :parent, :dependent => :destroy
  has_many :songs, as: :parent, :dependent => :destroy
  has_many :books, as: :parent, :dependent => :destroy
  has_many :photo_arts, as: :parent, :dependent => :destroy
  has_many :productions, as: :parent, :dependent => :destroy
  has_many :collection_albums, as: :parent, :dependent => :destroy
  has_many :links, as: :parent, :dependent => :destroy
  has_many :gallery_photos, as: :parent, :dependent => :destroy
  has_many :suggested_updates, as: :parent, :dependent => :destroy
  has_many :nominees, foreign_key: :recipient_id, foreign_type: :recipient_type
  has_many :nominations, through: :nominees, source: :award_category
  has_many :awards, through: :nominations

  has_and_belongs_to_many :performing_events
  has_many :artist_fans, :dependent => :destroy

  #has_and_belongs_to_many :industries
  has_and_belongs_to_many :artist_specialities
  has_and_belongs_to_many :directed_productions, join_table: :directors_productions, class_name: 'Production'
  has_and_belongs_to_many :acted_productions, class_name: 'Production', join_table: :artists_productions
  has_and_belongs_to_many :performed_songs, class_name: 'Song', join_table: :artists_songs

  has_and_belongs_to_many :blog_links, class_name: 'Blog', join_table: :artists_blogs
  has_and_belongs_to_many :news_stories_links, class_name: 'NewsStory', join_table: :artists_news_stories

  has_many :page_admins, as: :page, :dependent => :destroy
  has_many :managing_users, through: :page_admins, source: :user

  has_many :impressions, as: :entity, dependent: :destroy

  validates_presence_of :profile_name, :name, :gender, :country_of_birth, :introduction

  validates_uniqueness_of :profile_name
  validates :introduction, length: { maximum: 1200 }
  validate :has_industry?

  default_scope -> {order('created_at desc')}
  scope :featured, -> { where(featured: true) }
  scope :viewable, -> { where(aasm_state: [:approved,:approved_with_changes])}
  has_and_belongs_to_many :industries, -> {where("name != 'Venue'")}

  aasm do
    state :new_profile, initial: true
    state :draft
    state :unreviewed
    state :approved
    state :approved_with_changes
    state :rejected
    state :unpublished
    state :edited

    event :save_draft do
      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :draft
      after do
        self.impressions.delete_all
      end
    end



    event :submit_for_review do
      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :unreviewed

      after do
        self.impressions.delete_all
        AdminMailer.submitted_for_review(self).deliver
      end
    end

    event :approve do
      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :approved
      after do
        ArtistMailer.approved(self).deliver
      end
    end

    event :approve_with_changes do
      before do
        @changes = self.previous_changes.except(:updated_at)
      end

      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :approved_with_changes

      after do
        ArtistMailer.approved_with_changes(self, @changes).deliver
      end
    end

    event :reject do
      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :rejected
      after do
        self.impressions.delete_all
        ArtistMailer.rejected(self).deliver
      end
    end

    event :unpublish do
      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :unpublished
      after do
        self.impressions.delete_all
        ArtistMailer.rejected(self).deliver
      end
    end

    event :submit_edit do
      before do
        @changes = self.previous_changes.except(:updated_at)
      end
      transitions from: [:new_profile, :draft, :unreviewed, :approved, :approved_with_changes, :rejected, :edited, :unpublished], to: :edited
      after do
        self.impressions.delete_all
        AdminMailer.edit_submitted_for_review(self, @changes).deliver
      end
    end
  end

  #this doesn't lok right, using it for nominees
  def title
    profile_name
  end

  def self.trending
    return Impression.where(entity_type: 'Artist').where('created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect{|artist_id,count| Artist.find_by_id(artist_id)}.compact
  end

  def self.industriess
    return Industry.where("name != ?", "Venue")
  end

  def viewable_works
    (books.viewable + songs.viewable + productions.viewable + photo_arts.viewable + collection_albums.viewable + directed_productions.viewable + acted_productions.viewable + performed_songs.viewable).sort_by(&:created_at).reverse
  end

  def works
    (books + songs + productions + photo_arts + collection_albums + directed_productions + acted_productions + performed_songs).sort_by(&:created_at).reverse
  end

  def self.trending_in_art
    @artists = Impression.joins(:artist).where('impressions.created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect do |artist_id, count|
      Artist.find_by_id(artist_id) if Artist.find_by_id(artist_id).industries.include?(Industry.find_by_name 'Art and Design')
    end.compact!
    @artists || []
  end

  def self.trending_in_fashion
    @artists = Impression.joins(:artist).where('impressions.created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect do |artist_id, count|
      Artist.find_by_id(artist_id) if Artist.find_by_id(artist_id).industries.include?(Industry.find_by_name 'Fashion')
    end.compact!
    @artists || []
  end

  def self.trending_in_productions
    @artists = Impression.joins(:artist).where('impressions.created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect do |artist_id, count|
      Artist.find_by_id(artist_id) if Artist.find_by_id(artist_id).industries.include?(Industry.find_by_name 'Film, TV and Theater')
    end.compact!
    @artists || []
  end

  def self.trending_in_literature
    @artists = Impression.joins(:artist).where('impressions.created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect do |artist_id, count|
      Artist.find_by_id(artist_id) if Artist.find_by_id(artist_id).industries.include?(Industry.find_by_name 'Literature')
    end.compact!
    @artists || []
  end

  def self.trending_in_music
    @artists = Impression.joins(:artist).where('impressions.created_at >= ?', 1.week.ago).group(:entity_id).order('count_id desc').count('id').collect do |artist_id, count|
      Artist.find_by_id(artist_id) if Artist.find_by_id(artist_id).industries.include?(Industry.find_by_name 'Music')
    end.compact!
    @artists || []
  end

  private
    def has_industry?
      return errors.add(:industries, 'must select at least one') if industries.empty?
      return errors.add(:industries, 'must select 2 max') if industries.size > 2
    end

end
